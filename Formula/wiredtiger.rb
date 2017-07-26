class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "http://www.wiredtiger.com"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/2.9.3/wiredtiger-2.9.3.tar.bz2"
  sha256 "2502a90d6b3d3cae0b1bf221cbfe13999d3bcb7f8bb9fa795ad870be4fc0e1e7"

  bottle do
    cellar :any
    sha256 "7101b550028d09af2a0e5d5bd3b4b47c587d27e123a384b41cbe8e825ca26c35" => :sierra
    sha256 "b90909c91f03c502f8a5c0bf68d779864b7e039454385c9ab74912b3bace6081" => :el_capitan
    sha256 "0b6d6b67ecdc501cd58b472b58a11008e224de96cdc0790ae95c4ead454a0d26" => :yosemite
  end

  depends_on "snappy"

  def install
    system "./configure", "--with-builtins=snappy,zlib",
                          "--with-python",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wt", "create", "table:test"
    system "#{bin}/wt", "drop", "table:test"
  end
end
