class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.2/birta-aarch64-apple-darwin.tar.xz"
      sha256 "46513fc69c1fef1117135db3f34d069b1793be19bc8d3dc4af0ecfeab385a441"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.2/birta-x86_64-apple-darwin.tar.xz"
      sha256 "02b4bd3a6146131f13097e1ca769d56ccbe321e2ee43bd10ebbd38ae9ac78126"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.2/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d733bbe0c9da01d4aa467bd451ef86d23bf022b9384df32ef9fb796f91b9ee2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.2/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1612ef774806907f2da8967ba43ddffe325ba0dc4838cc17529dbc86f0ef51f4"
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
