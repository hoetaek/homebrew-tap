class Wt < Formula
  desc "Git worktree workspace manager"
  homepage "https://github.com/hoetaek/wt"
  version "0.26.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/wt/releases/download/v0.26.2/wt-aarch64-apple-darwin.tar.xz"
      sha256 "3def91048c8a08b9a396b53b321f4d9e5f2051999abc86607bdf430e6f502620"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/wt/releases/download/v0.26.2/wt-x86_64-apple-darwin.tar.xz"
      sha256 "ac9edf3bf9ff0f27be3b073a376242ba06630d8f168560ce44a3230ee8d19b21"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/wt/releases/download/v0.26.2/wt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9e59d0f4c4312416762c236cc3085cc023093de2cfa97d529b4357e071158615"
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
