class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/hoetaek/doist"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/doist/releases/download/v0.3.7/doist-aarch64-apple-darwin.tar.xz"
      sha256 "d78080f1f71bcda658a024a26ae138c257411250f409496cfc09bdc6c5a34172"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/doist/releases/download/v0.3.7/doist-x86_64-apple-darwin.tar.xz"
      sha256 "39d45e53cd23908b0f3119ab5739153b1f8aca2fbc70c46d66dded86313e16d8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/doist/releases/download/v0.3.7/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "dad60ead34fa4a0fcd0fc6914751e74d0511102cff965c16fc62d81936d89033"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
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
    bin.install "doist" if OS.mac? && Hardware::CPU.arm?
    bin.install "doist" if OS.mac? && Hardware::CPU.intel?
    bin.install "doist" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
