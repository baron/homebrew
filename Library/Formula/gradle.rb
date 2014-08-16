require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://downloads.gradle.org/distributions/gradle-2.0-bin.zip'
  sha1 '171d2290257c061a96410297f2596596862a847a'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.11-rc-1-bin.zip'
    sha1 'd5c1e564a788faa7fd109a17e0412a86a7b37502'
    version '1.11-rc-1'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
