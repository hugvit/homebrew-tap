class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.10.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.4/birta-aarch64-apple-darwin.tar.xz"
      sha256 "63939109e9882f87df3ec5bc82a800cf53acd8f2119e102af9bc605b44e2d2cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.4/birta-x86_64-apple-darwin.tar.xz"
      sha256 "921e11fe32b27d476a9b1005b93dccfee656ae52658cd20c9c51e3a661f2211c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.4/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d58e9680492d0af6806d5170adbf6110489b3c40b1ba621b09e1879427773b8d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.4/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8888cb27db4ecc917c29214a80df63055b20cdf7fdacb172a82da6957ea3226"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "birta"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "birta"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "birta"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "birta"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
