class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "http://www.openvdb.org/"
  url "https://github.com/dreamworksanimation/openvdb/archive/v3.2.0.tar.gz"
  sha256 "b9c765f8715974aee0cd92ca5fd7cf6c675e72d3a4d1c6b5084fb7ae13345398"
  revision 1

  head "https://github.com/dreamworksanimation/openvdb.git"

  bottle do
    sha256 "94a284f7e3247e313c1e2be481d1dcf2e680789a325ab54f05b35e0d650382d1" => :el_capitan
    sha256 "5c50cca8555c45fb08cc60715d35ab2278536928075ef97937cd1c92a16c1af6" => :yosemite
    sha256 "9c59fdd29ab1525b397815f246e7836b967fc678f1ac349fdebf908452f59ac3" => :mavericks
  end

  option "with-viewer", "Installs the command-line tool to view OpenVDB files"
  option "with-test", "Installs the unit tests for the OpenVDB library"
  option "with-logging", "Requires log4cplus"
  option "with-docs", "Installs documentation"

  deprecated_option "with-tests" => "with-test"

  depends_on "openexr"
  depends_on "ilmbase"
  depends_on "tbb"
  depends_on "jemalloc" => :recommended

  if MacOS.version < :mavericks
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "boost@1.61"
  end

  depends_on "homebrew/versions/glfw3" if build.with? "viewer"
  depends_on "cppunit" if build.with? "test"
  depends_on "doxygen" if build.with? "docs"
  depends_on "log4cplus" if build.with? "logging"
  needs :cxx11

  resource "test_file" do
    url "http://www.openvdb.org/download/models/cube.vdb.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    ENV.cxx11
    # Adjust hard coded paths in Makefile
    args = [
      "DESTDIR=#{prefix}",
      "BOOST_INCL_DIR=#{Formula["boost"].opt_lib}/include",
      "BOOST_LIB_DIR=#{Formula["boost"].opt_lib}",
      "BOOST_THREAD_LIB=-lboost_thread-mt",
      "TBB_INCL_DIR=#{Formula["tbb"].opt_lib}/include",
      "TBB_LIB_DIR=#{Formula["tbb"].opt_lib}/lib",
      "EXR_INCL_DIR=#{Formula["openexr"].opt_lib}/include",
      "EXR_LIB_DIR=#{Formula["openexr"].opt_lib}/lib",
      "BLOSC_INCL_DIR=", # Blosc is not yet supported.
      "PYTHON_VERSION=",
      "NUMPY_INCL_DIR=",
    ]

    if build.with? "jemalloc"
      args << "CONCURRENT_MALLOC_LIB_DIR=#{Formula["jemalloc"].opt_lib}/lib"
    else
      args << "CONCURRENT_MALLOC_LIB="
    end

    if build.with? "viewer"
      args << "GLFW_INCL_DIR=#{Formula["homebrew/versions/glfw3"].opt_lib}/include"
      args << "GLFW_LIB_DIR=#{Formula["homebrew/versions/glfw3"].opt_lib}/lib"
      args << "GLFW_LIB=-lglfw3"
    else
      args << "GLFW_INCL_DIR="
      args << "GLFW_LIB_DIR="
      args << "GLFW_LIB="
    end

    if build.with? "docs"
      args << "DOXYGEN=doxygen"
    else
      args << "DOXYGEN="
    end

    if build.with? "test"
      args << "CPPUNIT_INCL_DIR=#{Formula["cppunit"].opt_lib}/include"
      args << "CPPUNIT_LIB_DIR=#{Formula["cppunit"].opt_lib}/lib"
    else
      args << "CPPUNIT_INCL_DIR=" << "CPPUNIT_LIB_DIR="
    end

    if build.with? "logging"
      args << "LOG4CPLUS_INCL_DIR=#{Formula["log4cplus"].opt_lib}/include"
      args << "LOG4CPLUS_LIB_DIR=#{Formula["log4cplus"].opt_lib}/lib"
    else
      args << "LOG4CPLUS_INCL_DIR=" << "LOG4CPLUS_LIB_DIR="
    end

    ENV.append_to_cflags "-I #{buildpath}"

    cd "openvdb" do
      system "make", "install", *args
      if build.with? "test"
        system "make", "vdb_test", *args
        bin.install "vdb_test"
      end
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
