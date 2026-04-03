class Ontomics < Formula
  desc "MCP server that extracts domain ontologies from Python codebases"
  homepage "https://github.com/EtienneChollet/ontomics"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.2/ontomics-aarch64-apple-darwin.tar.xz"
      sha256 "316b9853e46fa1f8c0b1cec49008c338274f04c997c633d77ccf799a26b17479"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.2/ontomics-x86_64-apple-darwin.tar.xz"
      sha256 "8ec18f1b31819fb24d290e3fe213870159761e089d8a54dc0c86b86ff2d1b4b3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/EtienneChollet/ontomics/releases/download/v0.2.2/ontomics-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "377b6ed3c931325b1f08501ff836cefffb44ed41480ad8debc40ba869150beb0"
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
