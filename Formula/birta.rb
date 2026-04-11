class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.5.0/birta-aarch64-apple-darwin.tar.xz"
      sha256 "ca02dd7c2e6e13e0c80781c854ed291b1764a82f09575a2b9c55989d59a748e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.5.0/birta-x86_64-apple-darwin.tar.xz"
      sha256 "8411529545f00ff25b68604fc804a68ee94b60e027b88d318d37228f8f0689cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.5.0/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "858172b7385b403e8aeb19922b88c7cadfd39048d3a4c3017319eecc230f21da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.5.0/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b5a690866be0c2c728949ad490a5ab94b8d2f56f1942bf1d29f5843a6584fbc"
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
