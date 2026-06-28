class Leaf < Formula
  desc "Domain-neutral human-agent collaboration CLI"
  homepage "https://github.com/hoetaek/leaf"
  version "0.15.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/leaf/releases/download/v0.15.2/leaf-aarch64-apple-darwin.tar.xz"
      sha256 "a3115803223eb851b356902f6ebebbfcdc778214d7c0a676969500967ebd63e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/leaf/releases/download/v0.15.2/leaf-x86_64-apple-darwin.tar.xz"
      sha256 "d23fec0efd86cebb7ad4b0b31ad7986ac95f2c2bc4eee2c4ec4ff3d9edaf3ade"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/leaf/releases/download/v0.15.2/leaf-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8898e874b2c0d182d1ba2ba6e88d0f46e3bc90d660f6b8b403e0d79e1058f09f"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "aarch64-pc-windows-gnu":   {},
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
