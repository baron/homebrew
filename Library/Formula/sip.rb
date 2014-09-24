require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url "https://downloads.sf.net/project/pyqt/sip/sip-4.16.3/sip-4.16.3.tar.gz"
  sha1 "7c4079d164ccbfe4a5274eaeebe8e3cc86e3a75a"

  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "sip: --with-python3 must be specified when using --without-python"
  end

  def pythons
    pythons = []
    ["python", "python3"].each do |python|
      next if build.without? python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      pythons << [python, version]
    end
    pythons
  end

  def install
    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s downloader.cached_location + ".hg", ".hg"
      # build.py doesn't run with python3
      system "python", "build.py", "prepare"
    end

    pythons.each do |python, version|
      ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

      # Note the binary `sip` is the same for python 2.x and 3.x
      system python, "configure.py",
                     "--deployment-target=#{MacOS.version}",
                     "--destdir=#{lib}/python#{version}/site-packages",
                     "--bindir=#{bin}",
                     "--incdir=#{include}",
                     "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
      system "make"
      system "make", "install"
      system "make", "clean" if pythons.length > 1
    end
  end

  def caveats
    "The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip."
  end
end
