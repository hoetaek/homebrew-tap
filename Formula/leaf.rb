class Leaf < Formula
  desc "Domain-neutral human-agent collaboration CLI"
  homepage "https://github.com/hoetaek/leaf"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoetaek/leaf/releases/download/v0.3.0/leaf-aarch64-apple-darwin.tar.xz"
      sha256 "54b3ce2ff417a9046b770419049c720db865fbacf9d1d5ce761e3c003bea0fee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoetaek/leaf/releases/download/v0.3.0/leaf-x86_64-apple-darwin.tar.xz"
      sha256 "e376c8cbd185fc4eb01b111176b0e114be221b42a0877faddb554398f65bb230"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hoetaek/leaf/releases/download/v0.3.0/leaf-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a4893a7de77aba87bc082bce751035f85fb4c55da98af51029f9097e04aa07fd"
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
