class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.10.tar.gz"
  sha256 "41321109f410fc9b9c182773cf68fc0dc525fa640ebf7f7ed855c3dfbe023fc6"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a538489555c1201252853388588b5b12330f81a79fb86b64858f27a0386ef436" => :high_sierra
    sha256 "33b215f0d3ee9bd1182b261025621f01ee42c0cc452475f206673e62e97b1092" => :sierra
    sha256 "65df30f85c36938e4c0c608e9849d784213dda13d717989755965377c74ae7a9" => :el_capitan
    sha256 "65df30f85c36938e4c0c608e9849d784213dda13d717989755965377c74ae7a9" => :yosemite
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
