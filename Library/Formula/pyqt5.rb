require 'formula'

class Pyqt5 < Formula
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.3.2/PyQt-gpl-5.3.2.tar.gz"
  sha1 "bb34d826a50b0735d1319dc51be6a094ba64b800"

  option 'enable-debug', "Build with debug symbols"
  option 'with-docs', "Install HTML documentation and python examples"

  depends_on :python3 => :recommended
  depends_on :python => :optional

  if (build.without? "python") && (build.without? "python3")
    odie "pyqt: --with-python must be specified when using --without-python3"
  end

  depends_on 'qt5'

  if build.with? 'python3'
    depends_on 'sip' => 'with-python3'
  else
    depends_on 'sip'
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
    pythons.each do |python, version|
      ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
      args = [ "--confirm-license",
               "--bindir=#{bin}",
               "--destdir=#{lib}/python#{version}/site-packages",
               # To avoid conflicst with PyQt (for Qt4):
               "--sipdir=#{share}/sip/Qt5/",
               # sip.h could not be found automatically
               "--sip-incdir=#{Formula.factory('sip').opt_prefix}/include",
               # Force deployment target to avoid libc++ issues
               "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "--verbose"]
      args << '--debug' if build.include? 'enable-debug'

      # addresses https://github.com/Homebrew/homebrew/issues/32370
      inreplace "configure.py", "qmake_QT=['webkitwidgets']", "qmake_QT=['webkitwidgets', 'printsupport']"

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean" if pythons.length > 1
    end
    doc.install 'doc/html', 'examples' if build.with? "docs"
  end

  test do
    system "pyuic5", "--version"
    system "pylupdate5", "-version"
    pythons.each do |python, version|
      system python, "-c", "import PyQt5"
    end
  end
end
