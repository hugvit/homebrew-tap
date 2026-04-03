class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.2.1/birta-aarch64-apple-darwin.tar.xz"
      sha256 "93e56ce6052b968a65e4ff0f6b5cb2245230fb2266f9d5deb96c38e9c4328e80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.2.1/birta-x86_64-apple-darwin.tar.xz"
      sha256 "bef3ca282aad1b5f55b9a618840edf6bfa5afea2c4a1f457175c57626ad58f44"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.2.1/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61c9b089593fcdd831a34b8ba55b2d6bb23fe21ed46b12025c9b2c3459d00fff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.2.1/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8ad9760cbb928e5908598ea1e966cfc6bb5037c6fd68db0e104afda71b111bc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "birta" if OS.mac? && Hardware::CPU.arm?
    bin.install "birta" if OS.mac? && Hardware::CPU.intel?
    bin.install "birta" if OS.linux? && Hardware::CPU.arm?
    bin.install "birta" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
