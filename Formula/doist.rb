class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/hoetaek/doist"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/doist/releases/download/v0.4.1/doist-aarch64-apple-darwin.tar.xz"
      sha256 "629e601f811be885c72ebb92dc9ae87033d6bf3f477a2eb091b271add60416e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/doist/releases/download/v0.4.1/doist-x86_64-apple-darwin.tar.xz"
      sha256 "f3e90fc0a84f3cca93e442da1a1eb5dd79532d9e92409df807e216307fa82fe5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/doist/releases/download/v0.4.1/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "96827fca6b87d0a7112e92d9c959ac805e74278382bf85e240a9caf24fd613b0"
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
