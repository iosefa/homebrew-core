class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "http://ltp.sourceforge.net/coverage/lcov.php"
  url "https://downloads.sourceforge.net/ltp/lcov-1.13.tar.gz"
  sha256 "44972c878482cc06a05fe78eaa3645cbfcbad6634615c3309858b207965d8a23"
  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c1f51d0175cc4998979a7d556c4f218c917eb884db43d88a84ef007af9316a7" => :sierra
    sha256 "60a39cebc7d60df4b3f5db3dc83b74327bb472b4ee874626efc36709b5670377" => :el_capitan
    sha256 "5e2d2a144846f0b04986507f0e0b2b20cee0e9db888a748cb50a6d89c8309826" => :yosemite
    sha256 "6e2ffa607ebeec0b4c58cabeb8831ed1fa2f410bdb9032030209ab50afb8082a" => :mavericks
  end

  def install
    inreplace %w[bin/genhtml bin/geninfo bin/lcov],
      "/etc/lcovrc", "#{prefix}/etc/lcovrc"
    system "make", "PREFIX=#{prefix}", "BIN_DIR=#{bin}", "MAN_DIR=#{man}", "install"
  end
end
