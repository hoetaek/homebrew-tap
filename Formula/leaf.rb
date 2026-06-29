class Leaf < Formula
  desc "Domain-neutral human-agent collaboration CLI"
  homepage "https://github.com/hoetaek/leaf"
  version "0.15.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/leaf/releases/download/v0.15.3/leaf-aarch64-apple-darwin.tar.xz"
      sha256 "391db52fe675dcb5206eb932e2eb52885791b4568c4ee9e56d8f7873bf81bef9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/leaf/releases/download/v0.15.3/leaf-x86_64-apple-darwin.tar.xz"
      sha256 "cd1ae0b1bb662ed4aa1991a04cd985b59dcf6499f13bc3fd072430186e7bea13"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/leaf/releases/download/v0.15.3/leaf-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "59a204a54fb1fb45b68e199e5807f1659b451f0c9773f1148aa882f008365572"
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
