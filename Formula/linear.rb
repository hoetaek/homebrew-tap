class Linear < Formula
  desc "Linear CLI — issues, documents, projects, and more"
  homepage "https://github.com/hoetaek/linear"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/linear/releases/download/v0.1.0/linear-aarch64-apple-darwin.tar.xz"
      sha256 "dadb92aadee5218245ed295cc2248f2b716031962ec21cc929172a55bc79b5ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/linear/releases/download/v0.1.0/linear-x86_64-apple-darwin.tar.xz"
      sha256 "85d13649f6b696b1df90faeacf0b8cad927d9e84a03a31e114171505e73cd2d9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/linear/releases/download/v0.1.0/linear-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cb8d013dca8d09a2361222a09e2a0e6e9a11baf91c5c805bfd7234041dc7b1ca"
  end
  license "MIT"

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
    bin.install "linear" if OS.mac? && Hardware::CPU.arm?
    bin.install "linear" if OS.mac? && Hardware::CPU.intel?
    bin.install "linear" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
