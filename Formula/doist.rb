class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/hoetaek/doist"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/doist/releases/download/v0.4.3/doist-aarch64-apple-darwin.tar.xz"
      sha256 "563c8083dcaa3a1a30d83bee9ea8e4edbf8938056bc998a60768a955878d0428"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/doist/releases/download/v0.4.3/doist-x86_64-apple-darwin.tar.xz"
      sha256 "8647866235a22dd1d9d7aad578abe8dc49b339b4c13208eb31f9a8f7257ca911"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/doist/releases/download/v0.4.3/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e69cfe98614c0715f9611f8aff783bab28d1957a8557a86f7cb19e6a9b3245ff"
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
