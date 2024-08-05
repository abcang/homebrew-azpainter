class Azpainter < Formula
  desc 'Full color painting software for Unix-like systems for illustration drawing.'
  homepage 'https://github.com/abcang/homebrew-azpainter'
  url 'https://gitlab.com/azelpg/azpainter/-/archive/v3.0.8/azpainter-v3.0.8.tar.gz'
  sha256 '5751dd6e7bc9110c9bdefe453833f5a44e091b1266def3fd125d5c427512033b'
  revision 1

  depends_on 'libpng'
  depends_on 'jpeg-turbo'
  depends_on 'libtiff'
  depends_on 'webp'
  depends_on 'svg2png' => :build
  depends_on 'ninja' => :build
  depends_on 'pkg-config' => :build

  def install
    # NOTE: https://github.com/Homebrew/brew/commit/4836ea0ba2119619697af87edf5fdb2280e90238
    ENV.append_path 'PKG_CONFIG_PATH', '/opt/X11/lib/pkgconfig'
    ENV.prepend_path 'HOMEBREW_INCLUDE_PATHS', '/opt/X11/include'
    ENV.prepend_path 'HOMEBREW_INCLUDE_PATHS', '/opt/X11/include/freetype2'
    ENV.prepend_path 'HOMEBREW_LIBRARY_PATHS', '/opt/X11/lib'

    system 'sed', '-i', '.bak', '/gtk-update-icon-cache/d; /update-desktop-database/d; /update-mime-database/d',
           'install.sh.in'
    system './configure', "--prefix=#{prefix}", 'LIBS=-lxi'
    cd 'build' do
      system 'ninja'
      system 'ninja', 'install'
    end

    app_name = `sed -n '/^Name=/s///p' desktop/azpainter.desktop`.chomp + '.app'
    locale = `defaults read -g AppleLocale | sed 's/@.*$$//g'`.chomp + '.UTF-8'
    system %(echo 'do shell script "LANG=#{locale} #{bin}/azpainter >/dev/null 2>&1 &"' | osacompile -o #{app_name})

    tmp_icon_png = '/tmp/azpainter_1024.png'
    system 'svg2png', 'desktop/azpainter.svg', tmp_icon_png
    mkdir_p '/tmp/azpainter.iconset'
    system 'sips', '-z', '16', '16',   tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_16x16.png'
    system 'sips', '-z', '32', '32',   tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_16x16@2x.png'
    system 'sips', '-z', '32', '32',   tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_32x32.png'
    system 'sips', '-z', '64', '64',   tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_32x32@2x.png'
    system 'sips', '-z', '128', '128', tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_128x128.png'
    system 'sips', '-z', '256', '256', tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_128x128@2x.png'
    system 'sips', '-z', '256', '256', tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_256x256.png'
    system 'sips', '-z', '512', '512', tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_256x256@2x.png'
    system 'sips', '-z', '512', '512', tmp_icon_png, '--out', '/tmp/azpainter.iconset/icon_512x512.png'
    cp tmp_icon_png, '/tmp/azpainter.iconset/icon_512x512@2x.png'
    system 'iconutil', '-c', 'icns', '/tmp/azpainter.iconset'
    cp '/tmp/azpainter.icns', "#{app_name}/Contents/Resources/applet.icns"

    rm_rf '/tmp/azpainter.iconset'
    rm '/tmp/azpainter.icns'
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
    system 'false'
  end
end
