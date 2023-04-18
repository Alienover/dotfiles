class Yabai < Formula
  desc "A tiling window manager for macOS based on binary space partitioning."
  homepage "https://github.com/koekeishiya/yabai"
  url "https://github.com/koekeishiya/yabai/releases/download/v5.0.3/yabai-v5.0.3.tar.gz"
  sha256 "f3dfbb022e5f99803d18979d44a1d5ff72609bed620621dd95238c3009ca586a"
  head "https://github.com/koekeishiya/yabai.git"

  depends_on :macos => :big_sur

  def install
    (var/"log/yabai").mkpath
    man.mkpath

    if build.head?
      system "make", "-j1", "install"
    end

    bin.install "#{buildpath}/bin/yabai"
    (pkgshare/"examples").install "#{buildpath}/examples/yabairc"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
    man1.install "#{buildpath}/doc/yabai.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/yabairc ~/.yabairc
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    Logs will be found in
      #{var}/log/yabai/yabai.[out|err].log

    If you are using the scripting-addition; remember to update your sudoers file:
      sudo visudo -f /private/etc/sudoers.d/yabai

    Build the configuration row by running:
      echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa"

    README: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition
    EOS
  end

  service do
    run opt_bin/"yabai"
    require_root true
    environment_variables PATH: std_service_path_env
    keep_alive true
    interval 30
    log_path "#{var}/log/yabai/yabai.out.log"
    error_log_path "#{var}/log/yabai/yabai.err.log"
    process_type :interactive
  end
  
  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
