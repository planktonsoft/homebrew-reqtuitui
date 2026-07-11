class Reqtuitui < Formula
  desc "A terminal UI for making HTTP requests"
  homepage "https://github.com/planktonsoft/reqtuitui"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-aarch64-apple-darwin.tar.xz"
      sha256 "252dbd6a00c37401c76c87b13e801ccbfc2fdc389cd8b939b83778ef72ea2bce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-x86_64-apple-darwin.tar.xz"
      sha256 "d720cd8225ded4ee1d3ff44011e14056b5eab2c6327baaf2c50cc6a7a227e247"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2e30f5fe8190a11284d3652eb1f49bec54fe3dd19a2bfac598ca9e25702cf1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.1/reqtuitui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c07fcf2546d0b3cd7eaa575a422019b026407c58dc926a191539189e7ad88dd8"
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
