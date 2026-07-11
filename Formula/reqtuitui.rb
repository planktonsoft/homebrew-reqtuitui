class Reqtuitui < Formula
  desc "A terminal UI for making HTTP requests"
  homepage "https://github.com/planktonsoft/reqtuitui"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-aarch64-apple-darwin.tar.xz"
      sha256 "7acaed7ee43e7f5a494e03d4ffc3431100c3f749f5e5de3e338b03b9c57b6484"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-x86_64-apple-darwin.tar.xz"
      sha256 "05817f8c6c625e8f33ccfc414818ec723b401cf626cf7179ed6dc589699493fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae361d953238512b8012c40bcbfad5a3d20523f3f5de14b052b59b31ca2ed0eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "953a75842e57210bf8969f28025e09de19f339e5d57f81b157795c69fad166ea"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "reqtuitui" if OS.mac? && Hardware::CPU.arm?
    bin.install "reqtuitui" if OS.mac? && Hardware::CPU.intel?
    bin.install "reqtuitui" if OS.linux? && Hardware::CPU.arm?
    bin.install "reqtuitui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
