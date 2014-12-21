require 'formula'

class Libdv < Formula
  homepage 'http://libdv.sourceforge.net'
  url 'https://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz'
  sha1 '2e5ba0e95f665d60e72cbebcf1c4989e0d6c92c8'

  bottle do
    cellar :any
    revision 1
    sha1 "52e46dd26669bd9b226bfb774eac76a4f3cab442" => :yosemite
    sha1 "035268b04e85f298530c3791b272e124fc62fa89" => :mavericks
    sha1 "cc99e4e39bd24188d03b841eb24a39d31574b83a" => :mountain_lion
  end

  depends_on 'popt'

  def install
    # This fixes an undefined symbol error on compile.
    # See the port file for libdv. http://libdv.darwinports.com/
    # This flag is the preferred method over what macports uses.
    # See the apple docs: http://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtktest",
                          "--disable-gtk",
                          "--disable-asm",
                          "--disable-sdltest"
    system "make install"
  end
end
