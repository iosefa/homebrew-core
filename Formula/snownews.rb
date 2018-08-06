class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/kouya/snownews"
  url "https://github.com/kouya/snownews/archive/1.6.10.tar.gz"
  sha256 "8c78067aef75e283df4b3cca1c966587b6654e9e84a3e6e5eb8bdd5829799242"

  bottle do
    sha256 "192c7a039cfc5d4f8041982da9a0b0510745e8680754aea64202440c8ace9d6b" => :high_sierra
    sha256 "bfa3d3dbdd0ffbb197163bbf35bcb9d033bbad76a478533e546697dff24addb6" => :sierra
    sha256 "4ba563f80e1a79532136538595e36bd1f802fcc396515cad3dccb5f7dfcd21e2" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "./configure", "--prefix=#{prefix}"

    # Must supply -lz because configure relies on "xml2-config --libs"
    # for it, which doesn't work on OS X prior to 10.11
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags} -L#{Formula["openssl"].opt_lib} -lz", "CC=#{ENV.cc}"
  end
end
