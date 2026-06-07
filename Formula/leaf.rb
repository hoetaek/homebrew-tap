class Leaf < Formula
  desc "Domain-neutral human-agent collaboration CLI"
  homepage "https://github.com/hoetaek/leaf"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/leaf/releases/download/v0.1.3/leaf-aarch64-apple-darwin.tar.xz"
      sha256 "cfa772f84eaf5df6b4684ad395a891d0b5d0ff24ad436aea83a33a13c07ce5ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/leaf/releases/download/v0.1.3/leaf-x86_64-apple-darwin.tar.xz"
      sha256 "58247c84fdb290868426b435c4e0b3eea1440ec31b5402fc00511c2bec298d94"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/leaf/releases/download/v0.1.3/leaf-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fa061f406b15d25601995d3e87001ad12bb0efe56a9c7cdb0483871285d0c9dc"
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
