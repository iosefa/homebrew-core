class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.3.1.tar.gz"
  sha256 "6ca7d696462a9d7109fd47e4143f0bb78683ec00aeb3bc2e4d8b245c1d5e3c13"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b9566ecb99a91fb105dd4bb0ce7059ff89eddabc495fb386d0d317f64308c4c" => :sierra
    sha256 "33faf556d7e8ef624f42acf31677deaa1708ffd787cb66b5d5e495b00b2b0f59" => :el_capitan
    sha256 "516a923705fd0f8688c3ca0737171555e2a8536e745a3ff6b437f18d070b90d5" => :yosemite
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
