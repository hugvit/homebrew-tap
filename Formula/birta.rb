class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.10.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.5/birta-aarch64-apple-darwin.tar.xz"
      sha256 "df4203def637edb4576980da1c3dbb4882ca44e66a95d70479e5b630fb269fc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.5/birta-x86_64-apple-darwin.tar.xz"
      sha256 "6b23a26ac546aa4d1455cb32951d45c459e1d19e964ed79b69678c21a927739b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.10.5/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c19d691d41628abeef72a846751c0f649184c96b8e0baf010e22ff9b571ee8a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.10.5/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4975573726642dbbb221a94563066e80aa7e6de12c646d77cf39ed9a69d3ad88"
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
