require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.2.3.tar.gz"
  sha256 "1b6342577fbdebadc01e3b63739fb4c55dcf3321740119486d4886ba308963f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "799504859bf743752a1b7018b0138374682682cde61067a38f1d8b414440217e" => :high_sierra
    sha256 "ea04bd37b2df2ea2824d8d87a506929bbcb443a99f9c2c1a04a2888c1baca577" => :sierra
    sha256 "20a11dc53ae3388fd819b7c8074eafab242eadeb79d4c3057eb5cb748205c8b7" => :el_capitan
    sha256 "abf62af86d0061fab31f92aabc3d5a9d1ff2d9f18a524d16a49313a94774bb81" => :yosemite
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "d6ce6262d87e3a4e153e86023ff56ae771554a41"
  end

  go_resource "github.com/rogpeppe/godeps" do
    url "https://github.com/rogpeppe/godeps.git",
        :revision => "e444a191d9b826975e788bb3c95511447393706d"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/juju/charmstore-client"
    dir.install buildpath.children - [buildpath/".brew_home"]
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/rogpeppe/godeps") { system "go", "install" }

    cd dir do
      system "godeps", "-x", "-u", "dependencies.tsv"
      system "go", "build", "github.com/juju/charmstore-client/cmd/charm"
      bin.install "charm"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/charm"
  end
end
