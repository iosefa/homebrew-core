class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/v0.7.2.tar.gz"
  sha256 "50046477d5d1a18aec131a56bd3f21170057d8a31fd6f30af706e31d5b14bd0a"
  head "https://github.com/shirkdog/pulledpork.git"

  bottle do
    cellar :any
    sha256 "5f6932d9bb05288c7cb44a5f520ceb6f40b2b0bbad1a530c1f685d17d3dab176" => :sierra
    sha256 "1ed9d60f5b61b10dcbaee64a412880d18f4a8b383a970058ae8fcddabf70d97f" => :el_capitan
    sha256 "df5100e17ef491d1cf9a01b472af6793b557c11e634aa03e070550a43e632ca6" => :yosemite
    sha256 "df4b7616a783b56d557e86c65a376be78dbc3df8075f9589a5b255888dce3aad" => :mavericks
  end

  depends_on "openssl"

  resource "Switch" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    sha256 "31354975140fe6235ac130a109496491ad33dd42f9c62189e23f49f75f936d75"
  end

  resource "Crypt::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/N/NA/NANIS/Crypt-SSLeay-0.72.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/N/NA/NANIS/Crypt-SSLeay-0.72.tar.gz"
    sha256 "f5d34f813677829857cf8a0458623db45b4d9c2311daaebe446f9e01afa9ffe8"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    chmod 0755, "pulledpork.pl"
    bin.install "pulledpork.pl"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    doc.install Dir["doc/*"]
    (etc/"pulledpork").install Dir["etc/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulledpork.pl -V")
  end
end
