class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.4.1/sbcl-1.4.1-source.tar.bz2"
  sha256 "e8c7c6068241b13941d357a0a1f5a04ba04c7c83a52b00f0fbe296770872aae1"
  head "https://git.code.sf.net/p/sbcl/sbcl.git"

  bottle do
    sha256 "a5843166c72ff4ffb275691d2736a2d3c04cee6d70cbc8639955e941cb91edeb" => :high_sierra
    sha256 "db621045a92096aff0faf660b82d76326b47ed162cf4a887ea18e0dc7d44c085" => :sierra
    sha256 "ada112e0d4f3f3977f368527f77a3463a4d374cd5630ebf80707c5ba99b072f4" => :el_capitan
  end

  option "with-internal-xref", "Include XREF information for SBCL internals (increases core size by 5-6MB)"
  option "without-ldb", "Don't include low-level debugger"
  option "without-sources", "Don't install SBCL sources"
  option "without-core-compression", "Build SBCL without support for compressed cores and without a dependency on zlib"
  option "without-threads", "Build SBCL without support for native threads"

  # Current binary versions are listed at https://sbcl.sourceforge.io/platform-table.html
  resource "bootstrap64" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.11/sbcl-1.2.11-x86-64-darwin-binary.tar.bz2"
    sha256 "057d3a1c033fb53deee994c0135110636a04f92d2f88919679864214f77d0452"
  end

  resource "bootstrap32" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.1.6/sbcl-1.1.6-x86-darwin-binary.tar.bz2"
    sha256 "5801c60e2a875d263fccde446308b613c0253a84a61ab63569be62eb086718b3"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c5ffdb11/sbcl/patch-make-doc.diff"
    sha256 "7c21c89fd6ec022d4f17670c3253bd33a4ac2784744e4c899c32fbe27203d87e"
  end

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    (buildpath/"version.lisp-expr").write('"1.0.99.999"') if build.head?

    bootstrap = MacOS.prefer_64_bit? ? "bootstrap64" : "bootstrap32"
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource(bootstrap)

    command = "#{tmpdir}/src/runtime/sbcl"
    core = "#{tmpdir}/output/sbcl.core"
    xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
    ]
    args << "--with-sb-core-compression" if build.with? "core-compression"
    args << "--with-sb-ldb" if build.with? "ldb"
    args << "--with-sb-thread" if build.with? "threads"
    args << "--with-sb-xref-internal" if build.with? "internal-xref"

    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    if build.with? "sources"
      bin.env_script_all_files(libexec/"bin", :SBCL_SOURCE_ROOT => pkgshare/"src")
      pkgshare.install %w[contrib src]

      (lib/"sbcl/sbclrc").write <<~EOS
        (setf (logical-pathname-translations "SYS")
          '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
            ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
        EOS
    end
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
