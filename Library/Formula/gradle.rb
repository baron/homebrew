require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-2.2.1-bin.zip'
  sha1 '97ae081bc8be8b691e21dcf792eff1630dbc8eb6'

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
