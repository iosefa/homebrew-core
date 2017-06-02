class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.1.tar.gz"
  sha256 "0b9a834ed32c642305bbbf26160cf8563ff7b2101c756c6234040495e85876b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a439d2b4ff8896b3a4f31764649d3427291f1600b496ae8ed6880cc9d9041d3a" => :sierra
    sha256 "9ee696182677a9706120abd2855837c21dc022dd66543329426340f74a9a65d7" => :el_capitan
    sha256 "a28bb0be6e94acb314755eebcef75bd269aa9feb754d1396ff6bbba389482aab" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
