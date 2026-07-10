class Reqtuitui < Formula
  desc "A terminal UI for making HTTP requests"
  homepage "https://github.com/planktonsoft/reqtuitui"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.0/reqtuitui-aarch64-apple-darwin.tar.xz"
      sha256 "56e1bfc93f678e5a2c52fb9c2804a9de0c016426efb86230d851b3df826c20d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.0/reqtuitui-x86_64-apple-darwin.tar.xz"
      sha256 "d5e2039a3dba30d2adad861349b02b3573435370469a803429656d580fd44354"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.0/reqtuitui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "636fdde1efda2d8ad15183912ce14642f6f438c734c2291fe227ea9e5e2ca041"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planktonsoft/reqtuitui/releases/download/v0.1.0/reqtuitui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89ede7df76f09872ff987eba0735cfd49bb4cc6e5e9e6646e9f0674a85e8ff63"
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
