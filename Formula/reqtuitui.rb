class Reqtuitui < Formula
  desc "A terminal UI for making HTTP requests"
  homepage "https://github.com/planktonsoft/reqtuitui"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.2/reqtuitui-aarch64-apple-darwin.tar.xz"
      sha256 "756adcd79003ac06ae4d6597d7a1544b527b0af5efd70f30d7dff41c581c8c17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.2/reqtuitui-x86_64-apple-darwin.tar.xz"
      sha256 "b8979c973f4ea2d4fe54e18322542f2dca65a9aa7746a8e98432746c4d641fd1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.2/reqtuitui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d108a00e69e636460e20ef11a4ef4478acdee5198fcb74b338c6c2171614489"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.2/reqtuitui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e50274a91978456399eca6cb00a6fc5132525e84d3d1b2e665bfcd025de36f26"
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
