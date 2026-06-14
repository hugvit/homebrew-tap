class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.7.0/birta-aarch64-apple-darwin.tar.xz"
      sha256 "3427fffe37a73d3b6d6b1e00c22d3e76c37c55e2bc81dda93c1e8a610569bab3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.7.0/birta-x86_64-apple-darwin.tar.xz"
      sha256 "9cd5510ab3d1e455820b1ba3bd3ee74a7ad03fed41fdb8b1aa66257e825386e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.7.0/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4839681e99a07a89913c9c5c3ec7472317f2e197684c5f12a4b9812476f59a6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.7.0/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b816e2cf7844600117b1594e10958915c9a2f27d13ea570735f367b55e27a8ae"
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
