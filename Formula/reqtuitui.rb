class Reqtuitui < Formula
  desc "A terminal UI for making HTTP requests"
  homepage "https://github.com/planktonsoft/reqtuitui"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.3/reqtuitui-aarch64-apple-darwin.tar.xz"
      sha256 "f10eff7524da6d9675ed1cba0706f7b4be9d757143b29ed623bed69bd4a6b4bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.3/reqtuitui-x86_64-apple-darwin.tar.xz"
      sha256 "cd084c397c8a501330be5d17e2f1b374c3446051b24cee52459634ddc01945fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.3/reqtuitui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "92bd04f94b1a4d9af5e96ad4860e4eb7312c57d9af23a26c7bb5dc9711ea7f03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.3/reqtuitui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b3aff833c7337ce8ae59528c0564895d72bba80e860fc0ff29f848b14d807bfe"
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
