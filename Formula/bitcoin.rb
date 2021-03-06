class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0.tar.gz"
  sha256 "ec5a2358ee868d845115dc4fc3ed631ff063c57d5e0a713562d083c5c45efb28"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "9575d66515d19908ea53b0502341bb06d1507c2ff494e4ca91d705c865cc757e" => :catalina
    sha256 "587a616fa3a7c3ee0fc574dca8bf7a502d462873bf993fcc4fca5b0f7188aed3" => :mojave
    sha256 "5ba0b0006772ab5665e3060b8e08be99ee8479d8ed88f9dd166b2a1d959204b5" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  plist_options manual: "bitcoind"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bitcoind</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
