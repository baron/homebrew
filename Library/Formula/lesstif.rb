require 'formula'

class Lesstif < Formula
  homepage 'http://lesstif.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/lesstif/lesstif/0.95.2/lesstif-0.95.2.tar.bz2'
  sha1 'b894e544d529a235a6a665d48ca94a465f44a4e5'

  depends_on :x11

  def install
    # LessTif does naughty, naughty, things by assuming we want autoconf macros
    # to live in wherever `aclocal --print-ac-dir` says they should.
    # Shame on you LessTif! *wags finger*
    inreplace 'configure', "`aclocal --print-ac-dir`", "#{share}/aclocal"

    # 'sed' fails if LANG=en_US.UTF-8 as is often the case on Macs.
    # The configure script finds our superenv sed wrapper, sets SED,
    # but then doesn't use that variable.
    ENV['LANG'] = 'C'

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-production",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static"

    system "make"

    # LessTif won't install in parallel 'cause several parts of the Makefile will
    # try to make the same directory and `mkdir` will fail.
    ENV.deparallelize
    system "make install"
  end
end
