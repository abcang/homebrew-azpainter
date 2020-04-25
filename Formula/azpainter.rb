class Azpainter < Formula
  desc "AzPainter"
  homepage "https://github.com/abcang/homebrew-azpainter"
  url "https://github.com/Symbian9/azpainter/archive/v2.1.6.tar.gz"
  sha256 "a2147e5b2a35280c8bef2afff5ed78c2fdff92544c6790165599b8bba367588b"

  depends_on "makeicns" => :build
  depends_on "svg2png" => :build
  depends_on :x11

  patch :p0 do
    url "https://gist.githubusercontent.com/abcang/a59322e115659d5948a849eaf745b916/raw/05dbd8f4cdfc26a837fd502c006a2b2d4399e5e6/azpainter.diff"
    sha256 "fd88a002afb3fe59358105678a5dcbf6c40be14938ee73a456d8f5232211ab23"
  end

  def install
    chmod "+x", "./install-sh"
    system "./configure",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    app_name = `sed -n '/^Name=/s///p' desktop/azpainter.desktop`.chomp + ".app"
    locale = `defaults read -g AppleLocale | sed 's/@.*$$//g'`.chomp + ".UTF-8"
    system %Q(echo 'do shell script "LANG=#{locale} #{bin}/azpainter >/dev/null 2>&1 &"' | osacompile -o #{app_name})
    system "svg2png", "desktop/icons/hicolor/scalable/apps/azpainter.svg", "/tmp/azpainter.png"
    system "makeicns", "-in", "/tmp/azpainter.png", "-out", "#{appname}/Contents/Resources/applet.icns"
    prefix.install app_name
  end

  def caveats; <<~EOS
    Please execute this command to register to Launchpad.
      ln -sf $(brew --prefix azpainter)/AzPainter.app /Applications/
  EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test azpainter`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
