class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.10.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.3/birta-aarch64-apple-darwin.tar.xz"
      sha256 "0a218b00a5ac8f2eca5525876f8550ab7fe0b275168b7da87ca813277d4c39b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.3/birta-x86_64-apple-darwin.tar.xz"
      sha256 "95c0f3c77bb5dc06742191b08c9f326d33d0a3ad8e18d2f18df138f0b6edc044"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.3/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7eb36575bca548417fca6a5cabd562de38e25f96602a334afd357034fbb104c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.3/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9f82e7315c73c2bdd94d15c9c4bf1caf006ecc04b4b8017766c57399d0de0c17"
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
