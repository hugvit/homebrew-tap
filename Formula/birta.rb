class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/hugvit/birta"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.11.0/birta-aarch64-apple-darwin.tar.xz"
      sha256 "ecc19b9f7dcd0034ae4090a3fc0a2945bb03d7898b63ab765cb35ec7c3fd607a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.11.0/birta-x86_64-apple-darwin.tar.xz"
      sha256 "796332d27ba3d33d57f2d9a3b08da91038a67bf10fa8d72d7fc16aaa59431550"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugvit/birta/releases/download/v0.11.0/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "015fa8a2223db23ff03548e9d530a263cf21f625948524687ababbeef14a5d0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugvit/birta/releases/download/v0.11.0/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8bc682c7180ab58823be21b8551377aa545a4e961916350cdeca835dedd17bfe"
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
