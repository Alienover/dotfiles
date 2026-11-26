# DevPod Unix socket forwarding

`unix-forward.patch` lets a DevPod workspace's SSH server forward to Unix sockets, so these work:

```sh
ssh -L /local.sock:/remote.sock WS.devpod      # socket to socket
ssh -L 127.0.0.1:PORT:/remote.sock WS.devpod   # TCP to socket
rex -S ssh://WS.devpod whoami                  # Rex's own SSH transport
```

Stock DevPod (checked up to `v0.7.0-alpha.34` and upstream `main`, Nov 2025) refuses all of them with
`open failed: administratively prohibited: unix forwarding is disabled`.

## Why

`devpod ssh --stdio` (the `ProxyCommand` in `~/.ssh/config`) runs `/usr/local/bin/devpod helper ssh-server` inside
the container. That server registers the `direct-streamlocal@openssh.com` handler but never sets
`LocalUnixForwardingCallback`, and `github.com/loft-sh/ssh` treats a nil callback as deny-all
(`vendor/github.com/loft-sh/ssh/streamlocal.go`). The patch adds an allow-all callback to both servers,
`pkg/ssh/server/ssh.go` and `pkg/ssh/server/ssh_container.go`. That matches OpenSSH's default
(`AllowStreamLocalForwarding yes`) and grants nothing a shell in the workspace doesn't already have.

Only the binary inside the container changes. The Mac's `devpod`, DevPod Desktop and OpenSSH stay stock.

## Build

Build the agent for the container's architecture, stamped with the Mac client's exact version. DevPod reinstalls the
container's agent whenever `devpod version` there differs from the Mac's, so a matching version keeps the patched one.

```sh
VERSION="$(devpod version)"                                   # e.g. v0.7.0-alpha.34
ARCH="$(ssh WS.devpod uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/')"
SRC=~/src/devpod                                              # anywhere

git clone --depth 1 --branch "$VERSION" https://github.com/loft-sh/devpod.git "$SRC"
git -C "$SRC" apply ~/src/dotfiles/install/darwin/patches/devpod/unix-forward.patch

docker run --rm -v "$SRC":/src -w /src \
  -e CGO_ENABLED=0 -e GOOS=linux -e GOARCH="$ARCH" -e GOFLAGS=-mod=vendor -e GOTOOLCHAIN=local \
  golang:1.24 \
  go build -ldflags "-s -w -X github.com/loft-sh/devpod/pkg/version.version=$VERSION" \
  -o "devpod-linux-$ARCH" .
```

No local Go needed. The build takes a few minutes and gives a static ~100 MB binary.

**Reuse a previous build.** `~/src/devpod` keeps the patched checkout and its `devpod-linux-$ARCH`. If
`git -C ~/src/devpod describe --tags` prints `$VERSION` and the binary for `$ARCH` is there, skip to Install. For a
new version or architecture, check out the new tag there (`git -C ~/src/devpod fetch --depth 1 origin tag "$VERSION"`,
`git -C ~/src/devpod checkout -f "$VERSION"`, then `apply` again) instead of cloning, and rebuild.

## Install into a workspace

```sh
scp "$SRC/devpod-linux-$ARCH" WS.devpod:/tmp/devpod-patched
shasum -a 256 "$SRC/devpod-linux-$ARCH"; ssh WS.devpod 'sha256sum /tmp/devpod-patched'   # must match
ssh WS.devpod 'sudo install -m 0755 -o root -g root /tmp/devpod-patched /usr/local/bin/devpod
               rm /tmp/devpod-patched'
```

Compare the checksums rather than trusting scp: through DevPod's `ProxyCommand` it can exit non-zero after copying
the whole file.

`install` replaces the file rather than writing into it, so SSH servers already running keep the old binary. New
connections get the patched one. Reconnect long-lived ones, such as `rex-devpod`'s agent session.

**No backup needed.** The stock agent is DevPod's release asset, so undo by installing it again:

```sh
ssh WS.devpod "curl -fsSL -o /tmp/devpod-stock https://github.com/loft-sh/devpod/releases/download/$VERSION/devpod-linux-$ARCH &&
               sudo install -m 0755 -o root -g root /tmp/devpod-stock /usr/local/bin/devpod && rm /tmp/devpod-stock"
```

Recreating the workspace does the same.

## Watch out

- **It doesn't survive** recreating the workspace (`devpod up --recreate`, rebuild) or upgrading DevPod on the Mac.
  Either one installs the stock agent again. Rebuild on the new tag and reinstall. Setting `DEVPOD_AGENT_URL` to
  where you host `devpod-linux-{amd64,arm64}` makes DevPod download the patched builds instead.
- **One install per workspace.** Each container has its own `/usr/local/bin/devpod`.
- **The version string must match exactly**, or the next `devpod up` / `devpod ssh` overwrites the binary.
- **Keep local socket paths under 104 bytes** (the macOS limit). A longer path fails to bind and looks like a
  dead forward. `~/.local/state/rex/devpod/WS.sock` fits; deep temp folders may not.
- Use `-o StreamLocalBindUnlink=yes` with socket-to-socket forwards, or a stale local socket blocks the next run.
- Check whether `git -C "$SRC" apply` still applies cleanly on a new tag. If it fails, re-add the
  `LocalUnixForwardingCallback` block by hand next to `ReverseUnixForwardingCallback` in both files.

## Done when

With `R=/home/vscode/.local/state/rex/run/server.sock` (the container's Rex socket):

- `ssh WS.devpod /usr/local/bin/devpod version` prints the same as `devpod version` on the Mac.
- `ssh -f -N -o StreamLocalBindUnlink=yes -L "$TMPDIR/ws.sock:$R" WS.devpod`, then
  `rex --autostart=false -S "unix://$TMPDIR/ws.sock" whoami --json` prints the container's `host_id`
  (compare with `ssh WS.devpod rex server status`).
- `rex --autostart=false -S ssh://WS.devpod whoami --json` prints the same `host_id`, principal `uid 1000`.
- `ssh -v -L ...` logs no `unix forwarding is disabled`.

Verified on `friday` (arm64, `v0.7.0-alpha.34`) on 2026-11-25.
