class Wt < Formula
  desc "Worktree-based agent orchestration harness"
  homepage "https://github.com/hoetaek/wt"
  version "0.45.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/wt/releases/download/v0.45.0/wt-aarch64-apple-darwin.tar.xz"
      sha256 "5bc36c8d0d18f19ca994dc369b836e7aed901387081a8fa516035b08e1d9b40c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/wt/releases/download/v0.45.0/wt-x86_64-apple-darwin.tar.xz"
      sha256 "35a5f273eefceccf41dabdcbc2b12cd541f36d29c0f6e4098d951115dd8bea87"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/wt/releases/download/v0.45.0/wt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b63dd884cccde7edeb44eba98dac19249774e582b70fce7325a81531cd4f2b48"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "wt" if OS.mac? && Hardware::CPU.arm?
    bin.install "wt" if OS.mac? && Hardware::CPU.intel?
    bin.install "wt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
