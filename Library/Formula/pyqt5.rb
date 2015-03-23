require 'formula'

class Pyqt5 < Formula
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.4/PyQt-gpl-5.4.tar.gz"
  sha1 "057e6b32c43e673e79f876fb9b6f33d3072edfc2"

  bottle do
    sha1 "5a7e7b91f9cc8d5b4ec3cfa5590cb200e98c4382" => :yosemite
    sha1 "2797239e99fe1d858d49b24b563be951b2c5fb9f" => :mavericks
    sha1 "6ceceadb5d76ff3b8a71300ac761b324d193dcea" => :mountain_lion
  end

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
    Language::Python.each_python(build) do |python, version|
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
