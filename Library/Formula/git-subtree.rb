require 'formula'

class GitSubtree < Formula
  homepage 'https://github.com/justone/git-subtree.git'
  url 'https://github.com/justone/git-subtree/archive/v0.4.tar.gz'
  sha1 'e78757d750a3854d97861f15a70927dea8a225b8'

  head 'https://github.com/justone/git-subtree.git'

  def options
    [['--build-docs', "Build man pages using asciidoc and xmlto"]]
  end

  if ARGV.include? '--build-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    if ARGV.include? '--build-docs'
      system "make doc"
      man1.install "git-subtree.1"
    else
      doc.install "git-subtree.txt"
    end
    bin.install "git-subtree.sh" => "git-subtree"
  end
end
