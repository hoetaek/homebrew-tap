class Leaf < Formula
  desc "Domain-neutral human-agent collaboration CLI"
  homepage "https://github.com/hoetaek/leaf"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/leaf/releases/download/v0.6.0/leaf-aarch64-apple-darwin.tar.xz"
      sha256 "aa83febc4aa0a99aab6ebc52501386380d2fabaafc6935ceb2d76564d044e536"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/leaf/releases/download/v0.6.0/leaf-x86_64-apple-darwin.tar.xz"
      sha256 "041186e8cb42b4d0cf44573cae8ef8c9e0791a66e612f4dd07fe30cd82ad1223"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/leaf/releases/download/v0.6.0/leaf-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ac4f271b9e46ebd6cbb7dec5e15c95884d766772f96df77ea95b33f90c00436a"
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
    bin.install "leaf" if OS.mac? && Hardware::CPU.arm?
    bin.install "leaf" if OS.mac? && Hardware::CPU.intel?
    bin.install "leaf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
