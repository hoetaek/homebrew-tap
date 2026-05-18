class Wt < Formula
  desc "Git worktree workspace manager"
  homepage "https://github.com/hoetaek/wt"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/wt/releases/download/v0.28.0/wt-aarch64-apple-darwin.tar.xz"
      sha256 "0fcad2df6ba25d185a39eff9564df21bc757cbc13f850ae266198ba20a839670"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/wt/releases/download/v0.28.0/wt-x86_64-apple-darwin.tar.xz"
      sha256 "0e224ccd47c2645ef5a4e9c78dc939d0a0bf903f1dfd6894ca5570a93c8134d0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/wt/releases/download/v0.28.0/wt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1ebd4657f851b84a7e70f8fc74be1608000c929aab29b6ae32b411c014e9d6b3"
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
