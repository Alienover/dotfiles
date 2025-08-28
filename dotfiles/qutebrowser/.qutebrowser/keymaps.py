config = config  # noqa # pyright: ignore[reportUndefinedVariable]

IGNORED_BINDINGS = ["+", "-", "=", "d", "q", "H", "J", "K", "L", "<Ctrl-h>"]

for lhs in IGNORED_BINDINGS:
    config.unbind(lhs)

keymaps = {
    # History back/forward
    "H": "back",
    "L": "forward",
    # Tabs navigation
    "[[": "tab-prev",
    "]]": "tab-next",
    # Zoom in/out/equal
    "<Meta-0>": "zoom",
    "<Meta-=>": "zoom-in",
    "<Meta-->": "zoom-out",
    "<Space>bb": "cmd-set-text -s :tab-focus",
    "<Ctrl-m>": "hint video spawn /opt/homebrew/bin/mpv {hint-url} --keep-open=yes",
    ";b": "blur-input",
    "gp": "open -p",
}


for lhs, rhs in keymaps.items():
    config.bind(lhs, rhs)

config.bind("<Escape>", "fake-key <Escape>", mode="normal")

config.bind("<Ctrl-n>", "completion-item-focus next", mode="command")
config.bind("<Ctrl-p>", "completion-item-focus prev", mode="command")
