require "language/go"

class Cosi < Formula
  desc "Implementation of scalable collective signing"
  homepage "https://github.com/dedis/cosi"
  url "https://github.com/dedis/cosi/archive/0.8.6.tar.gz"
  sha256 "007e4c4def13fcecf7301d86f177f098c583151c8a3d940ccb4c65a84413a9eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e73fd1b11e66d3931c91d6504b9958d44059aa4f3bbc547ed6cc8bdbc3717c6e" => :el_capitan
    sha256 "2953f8c62a93c976bf450d9605cab850d6d442e9e1885f3a455243942e59f6dd" => :yosemite
    sha256 "73d73bd817f6700c751a9065133ea460115ee5e5dbbff89d0655137bee30ef1f" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "f0aeabca5a127c4078abb8c8d64298b147264b55"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
      :revision => "511bcaf42ccd42c38aba7427b6673277bf19e2a1"
  end

  go_resource "github.com/dedis/crypto" do
    url "https://github.com/dedis/crypto.git",
      :revision => "d9272cb478c0942e1d60049e6df219cba2067fcd"
  end

  go_resource "github.com/dedis/protobuf" do
    url "https://github.com/dedis/protobuf.git",
      :revision => "6948fbd96a0f1e4e96582003261cf647dc66c831"
  end

  go_resource "github.com/montanaflynn/stats" do
    url "https://github.com/montanaflynn/stats.git",
      :revision => "60dcacf48f43d6dd654d0ed94120ff5806c5ca5c"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "f9ab0dce87d815821e221626b772e3475a0d2749"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "0c607074acd38c5f23d1344dfe74c977464d1257"
  end

  go_resource "gopkg.in/codegangsta/cli.v1" do
    url "https://gopkg.in/codegangsta/cli.v1.git",
      :revision => "01857ac33766ce0c93856370626f9799281c14f4"
  end

  go_resource "gopkg.in/dedis/cothority.v0" do
    url "https://gopkg.in/dedis/cothority.v0.git",
      :revision => "e5eb384290e5fd98b8cb150a1348661aa2d49e2a"
  end

  def install
    mkdir_p buildpath/"src/github.com/dedis"
    ln_s buildpath, buildpath/"src/github.com/dedis/cosi"

    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "cosi"
    prefix.install "dedis_group.toml"
    bin.install "cosi"
  end

  test do
    (testpath/"test.txt").write("This is my test file")
    group = prefix/"dedis_group.toml"
    file = prefix/"README.md"
    sig = shell_output("#{bin}/cosi sign -g #{group} #{file}")
    sigfile = "sig.json"
    (testpath/sigfile).write(sig)
    assert_match "OK", shell_output("#{bin}/cosi verify -g #{group} -s #{sigfile} #{file}")
  end
end
