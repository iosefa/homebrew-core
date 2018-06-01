class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.1.tar.gz"
  sha256 "785f206030b71f0117c975226f490aa370ee5eda36597010677794b539151743"

  bottle do
    sha256 "f766c8896858032abb1d65559ffa4b09b2e508e3de51a570c509abd98aeb7e29" => :high_sierra
    sha256 "dde34dd1ee08a272a40452ee51028fcb06589f0cc817745af811bd2b00707647" => :sierra
    sha256 "4a6ee623a2d226fe63f316dc52ea9f14ed152a2943122ff40a02f93174f1bd77" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/fselect"
  end

  test do
    (testpath/"test.txt").write("")
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
