require 'formula'

class W3m < Formula
  url 'http://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.3/w3m-0.5.3.tar.gz'
  homepage 'http://w3m.sourceforge.net/'
  md5 '1b845a983a50b8dec0169ac48479eacc'

  depends_on 'bdw-gc'

  fails_with_llvm

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
