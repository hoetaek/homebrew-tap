class Wt < Formula
  desc "Git worktree workspace manager"
  homepage "https://github.com/hoetaek/wt"
  url "https://github.com/hoetaek/wt/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "220255b86408cc9bef48f46e16543baf4c3eb822f5ccc48cea5347ac72da3cd9"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wt --version")
  end
end
