class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.6.1.tar.gz"
  sha256 "8438793d39655405ee565d80d361553f9e485e684f361f74b6e199ac93ac2fed"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25005c688506066c69fc2ca12cf9b351fbfa407a258807f84b55dbf2ec35f14c" => :sierra
    sha256 "2412d7a6ab8631910becf70fc6749b9746da002145582b0ad9fbbf225ba31369" => :el_capitan
    sha256 "365a758d97ee79f1601d36848f8efb2b5466eb70256ef2ad78129169cc363c0b" => :yosemite
    sha256 "83e5d999746477c29d8d42f9e16554d248a97528abc311ab3bd880f819ccc94c" => :mavericks
  end

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    assert_match %r{https:\/\/gist}, pipe_output("#{bin}/gist", "homebrew")
  end
end
