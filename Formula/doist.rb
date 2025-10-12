class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/hoetaek/doist"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/doist/releases/download/v0.4.4/doist-aarch64-apple-darwin.tar.xz"
      sha256 "f39abb743016b112fb6f4cf07cb6b4fdbad1caa1c3a15e3110775df4be21783e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/doist/releases/download/v0.4.4/doist-x86_64-apple-darwin.tar.xz"
      sha256 "ea1d0a716a22e3e260b2a5d846d598c3e5cf8d1bff7854271c135eeb64bc1a58"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/doist/releases/download/v0.4.4/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "bcde6220337981b9cb687657970fa98fdc81ff333193c6336a544b77f5a73535"
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
