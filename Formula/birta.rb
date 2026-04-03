class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.3.0/birta-aarch64-apple-darwin.tar.xz"
      sha256 "7434c4cf701235d115ed33a87f2cfa2b1ab1f15e0b2df461cfda0bccd1fd18e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.3.0/birta-x86_64-apple-darwin.tar.xz"
      sha256 "a56433648258fd30246d068615f20c83626849adc9983199f38bcff9f2902db9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.3.0/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "16e9cf3f9df9d1ed6916c8c6186edc82e42245a08d1d9737539004f97078ad4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.3.0/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30901be6335054a5e478639bb3fb21ae38bfd29a7c3f535edc574884210a5a6d"
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
