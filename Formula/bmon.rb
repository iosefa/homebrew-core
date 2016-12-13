class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"

  bottle do
    sha256 "5764df478a5fd162c212b989aa22060d94100ec8becda51493adeb2215479fed" => :sierra
    sha256 "6673c478d4f7558bab1ce6f1939d24bc8b88f81f3f31a92cf447317f8143cdf0" => :el_capitan
    sha256 "e70015fe4b38f8c75783ac2d3a6f828d4a6d20ef7fbbb95378483fa2a22af7d4" => :yosemite
    sha256 "dba21c9ad3060c78df2d11b71b6a23dd1a7dc609648fd0562cf59e08f45a7884" => :mavericks
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
