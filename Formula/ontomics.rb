class Ontomics < Formula
  desc "MCP server that extracts domain ontologies from Python codebases"
  homepage "https://github.com/EtienneChollet/ontomics"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.0/ontomics-aarch64-apple-darwin.tar.xz"
      sha256 "9883ad12f7b410d2ef6de44b5a303d790fbc666756d23da4acdbdb6b919d365f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.0/ontomics-x86_64-apple-darwin.tar.xz"
      sha256 "905be750550318703a29968927156398cf64e4e0ddb8cbcc35dbb53fef9ea463"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.0/ontomics-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fe8da83566965f45f98f6330a5c371f0cef9786b4516fd7312fcd147924cf6e4"
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
