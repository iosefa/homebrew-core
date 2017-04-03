class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2017.04.03.00.tar.gz"
  sha256 "f1ea25cf6b160fadd440431c42e1ef99ef6d61896b4d1b9c13728a0e83a6f65f"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "7fdb7ded2e05c95d1b00f48ae6d609bcf10ac66c5b0694d8cc741c7d1e52d32a" => :sierra
    sha256 "9111e934c9b6596f82b7925f7b5ebd82d6a2649e42068b1fcdf3e3a44be3aedd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"
  depends_on "xz"
  depends_on "snappy"
  depends_on "lz4"
  depends_on "openssl"

  # https://github.com/facebook/folly/issues/451
  depends_on :macos => :el_capitan

  needs :cxx11

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  patch do
    url "https://github.com/facebook/folly/pull/568.patch"
    sha256 "c0104aba1ddfa1639e138e32d2f1210a9e577a74a0e683b5ed6ab92ce1e10510"
  end

  def install
    ENV.cxx11

    cd "folly" do
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                            "--disable-dependency-tracking"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
