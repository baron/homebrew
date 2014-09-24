require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://downloads.gradle.org/distributions/gradle-2.1-bin.zip'
  sha1 'b8fa88f4053452b0b09f159b8668ce08e4dc5fa8'

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
