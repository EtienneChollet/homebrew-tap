class Ontomics < Formula
  desc "MCP server that extracts domain ontologies from Python codebases"
  homepage "https://github.com/EtienneChollet/ontomics"
  version "0.1.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.1.14/ontomics-aarch64-apple-darwin.tar.xz"
      sha256 "2b3238a4427172bb9e2cc6842fc4ee87888cc6ef8f07abb2065cf6e0b3949385"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.1.14/ontomics-x86_64-apple-darwin.tar.xz"
      sha256 "e3fdbc5cace21ad76085490de1b24d354a927d927db28cf9be26e93477ca4100"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/EtienneChollet/ontomics/releases/download/v0.1.14/ontomics-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "19260fa236a3f07d1553d1a88ee568230c438d6ed730fd6d2a1d4ea375496ec2"
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
