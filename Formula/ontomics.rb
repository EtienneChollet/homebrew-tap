class Ontomics < Formula
  desc "MCP server that extracts domain ontologies from Python codebases"
  homepage "https://github.com/EtienneChollet/ontomics"
  version "0.1.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.1.17/ontomics-aarch64-apple-darwin.tar.xz"
      sha256 "33d0b6fc7b13cd226d1b58503f03f6e97e22c72bf5e9998ae51fc032d6ceb2ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.1.17/ontomics-x86_64-apple-darwin.tar.xz"
      sha256 "29fe2e1c8dd7683a311762f69d7e98cc48d853fdcbd9fcdbf5d5366017cee2c7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/EtienneChollet/ontomics/releases/download/v0.1.17/ontomics-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "45d953a5c56ce52fe322d66143e4be694cdc023afb1bf27dafcb3fafb34e5203"
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
