class Azpainter < Formula
  desc "AzPainter"
  homepage "https://github.com/abcang/homebrew-azpainter"
  url "https://github.com/Symbian9/azpainter/archive/v2.1.4.tar.gz"
  sha256 "b52a67b6ea31b84447b9f8172daa75bdc0c004540776ab45912215a688b99db9"

  depends_on "makeicns" => :build
  depends_on "jpeg-turbo"
  depends_on :x11

  patch :p0 do
    url "https://gist.githubusercontent.com/abcang/a59322e115659d5948a849eaf745b916/raw/0a6ffa3c800c598edf590b90035566984afa54aa/azpainter.diff"
    sha256 "347d587fe9152043a998fccfb124cead02484f4b9b5342fab0615848e6564b15"
  end

  def install
    chmod "+x", "./install-sh"
    system "./configure",
      "--with-freetype-dir=#{MacOS::X11.include}/freetype2",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    app_name = `sed -n '/^Name=/s///p' desktop/azpainter.desktop`.chomp + ".app"
    locale = `defaults read -g AppleLocale | sed 's/@.*$$//g'`.chomp + ".UTF-8"
    system %Q(echo 'do shell script "LANG=#{locale} #{bin}/azpainter >/dev/null 2>&1 &"' | osacompile -o #{app_name})
    system "makeicns", "-in", "desktop/azpainter.png", "-out", "#{app_name}/Contents/Resources/applet.icns"
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
