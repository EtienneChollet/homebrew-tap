class Ontomics < Formula
  desc "MCP server that extracts domain ontologies from Python codebases"
  homepage "https://github.com/EtienneChollet/ontomics"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.1/ontomics-aarch64-apple-darwin.tar.xz"
      sha256 "6188f8257aeae644f2440a696471b50fad7e65ae1933cdb372873598a70419fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.1/ontomics-x86_64-apple-darwin.tar.xz"
      sha256 "7f39a6c7e9568fa8f6f12003bda166f025f5836b4669dc922d792768d2be4558"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.1/ontomics-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a72fe0d23f22d57f5f013d15e706b272ec0c92301ac94d94527fc72b98e4b33e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "ontomics" if OS.mac? && Hardware::CPU.arm?
    bin.install "ontomics" if OS.mac? && Hardware::CPU.intel?
    bin.install "ontomics" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
