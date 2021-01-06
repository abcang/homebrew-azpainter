class Azpainter < Formula
  desc "Full color painting software for Unix-like systems for illustration drawing."
  homepage "https://github.com/abcang/homebrew-azpainter"
  url "https://github.com/Symbian9/azpainter/archive/v2.1.6.tar.gz"
  sha256 "a2147e5b2a35280c8bef2afff5ed78c2fdff92544c6790165599b8bba367588b"
  revision 1

  # When using libx11, "malloc: *** error for object 0x27: pointer being freed was not allocated" occurs
  # depends_on "libx11"
  # depends_on "libxext"
  # depends_on "libxi"
  # depends_on "freetype"
  # depends_on "fontconfig"

  depends_on "libpng"
  depends_on "libjpeg"
  depends_on "svg2png" => :build

  uses_from_macos "zlib"

  patch :p0 do
    url "https://gist.githubusercontent.com/abcang/a59322e115659d5948a849eaf745b916/raw/1a51bce4c7ee8e1b364e0c16a89309b92dc76339/azpainter.diff"
    sha256 "8a5651b330e526b4d31435d472f8dbb02d355c86d71ee7ace0dfb7bf95a2acca"
  end

  def install
    ENV.prepend_path "HOMEBREW_INCLUDE_PATHS", MacOS::XQuartz.include.to_s
    ENV.prepend_path "HOMEBREW_INCLUDE_PATHS", "#{MacOS::XQuartz.include}/freetype2"
    ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", MacOS::XQuartz.lib.to_s

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    app_name = `sed -n '/^Name=/s///p' desktop/applications/azpainter.desktop`.chomp + ".app"
    locale = `defaults read -g AppleLocale | sed 's/@.*$$//g'`.chomp + ".UTF-8"
    system %Q(echo 'do shell script "LANG=#{locale} #{bin}/azpainter >/dev/null 2>&1 &"' | osacompile -o #{app_name})

    tmp_icon_png = "/tmp/azpainter_1024.png"
    system "svg2png", "desktop/icons/hicolor/scalable/apps/azpainter.svg", tmp_icon_png
    mkdir_p "/tmp/azpainter.iconset"
    system "sips", "-z", "16", "16",   tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_16x16.png"
    system "sips", "-z", "32", "32",   tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_16x16@2x.png"
    system "sips", "-z", "32", "32",   tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_32x32.png"
    system "sips", "-z", "64", "64",   tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_32x32@2x.png"
    system "sips", "-z", "128", "128", tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_128x128.png"
    system "sips", "-z", "256", "256", tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_128x128@2x.png"
    system "sips", "-z", "256", "256", tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_256x256.png"
    system "sips", "-z", "512", "512", tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_256x256@2x.png"
    system "sips", "-z", "512", "512", tmp_icon_png, "--out", "/tmp/azpainter.iconset/icon_512x512.png"
    cp tmp_icon_png, "/tmp/azpainter.iconset/icon_512x512@2x.png"
    system "iconutil", "-c", "icns", "/tmp/azpainter.iconset"
    cp "/tmp/azpainter.icns", "#{app_name}/Contents/Resources/applet.icns"

    rm_rf "/tmp/azpainter.iconset"
    rm "/tmp/azpainter.icns"
    rm tmp_icon_png

    prefix.install app_name
  end

  def caveats
    <<~EOS
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
