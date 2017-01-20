class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "https://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.4.tar.gz"
  sha256 "c59b244b2d4e87e04491898a401238ea6f302326957ffe1aeb6154485fe1d8ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "18e0780dabcd28d1f579574f8bb9aa09bddc53bdf1f6c3804b9d9a37463fa121" => :sierra
    sha256 "310cfc77e1edddab84270547c87c567958cb44d25437dfd4793f0a461b5b7de5" => :el_capitan
    sha256 "be5c1307443b5fbf5a9cbeb027af3c1960f09b0318bc589850299afd5694b52e" => :yosemite
    sha256 "e7550c86cdbf3618cb89445067aff24733c0786817760ed87b1c38268fc1b808" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deis", "client/deis.go"
  end

  test do
    system bin/"deis", "logout"
  end
end
