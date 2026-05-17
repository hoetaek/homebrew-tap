class Wt < Formula
  desc "Git worktree workspace manager"
  homepage "https://github.com/hoetaek/wt"
  version "0.26.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/wt/releases/download/v0.26.1/wt-aarch64-apple-darwin.tar.xz"
      sha256 "5edb96a387923bf5d1f9fe291805b2501d64df1181826c8491a9d2d974509fa6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/wt/releases/download/v0.26.1/wt-x86_64-apple-darwin.tar.xz"
      sha256 "0edd3aca089d05f1d7aacd22e060db67cc31f8548545be8ca7f6883844a2993b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/wt/releases/download/v0.26.1/wt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "14643f38d2ea42fbc78f4f9ed25f269cda5312870cc8937df1260630cb0e66e0"
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
