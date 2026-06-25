class Wt < Formula
  desc "Worktree-based agent orchestration harness"
  homepage "https://github.com/hoetaek/wt"
  version "0.49.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/wt/releases/download/v0.49.0/wt-aarch64-apple-darwin.tar.xz"
      sha256 "ef73b9a6e26c3eb8a038fe7d023b08bbcb826fb58abf00c9f643171a95fbb8a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/wt/releases/download/v0.49.0/wt-x86_64-apple-darwin.tar.xz"
      sha256 "1ceeedc534f1b89ab2e60d7b029b4279114ac59d0a7ccdf727d709f4f1fd4744"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/wt/releases/download/v0.49.0/wt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "871590ad4d60cf98a7c2c6e47b05b13ec81a38c4d0255332a738cd80a945dac1"
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
