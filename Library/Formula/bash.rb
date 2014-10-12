require "formula"

class Bash < Formula
  homepage "http://www.gnu.org/software/bash/"

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"

    mirror "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.30"

    # Vendor the patches. The mirrors are unreliable for getting the patches,
    # and the more patches there are, the more unreliable they get. Upstream
    # patches can be found in: http://git.savannah.gnu.org/cgit/bash.git
    patch do
      url "https://gist.githubusercontent.com/jacknagel/c1cf23775c774e2b4b6d/raw/c2b0a715efbc8a302741e6b682605940042fc2b8/bash-4.3.30.diff"
      sha1 "61996c0a78d2d07184576783a56a7b315eb16d55"
    end
  end

  bottle do
    sha1 "90cb996eec0339748d484b6c9634291040e5465d" => :mavericks
    sha1 "d58702a5c70288a53369068bf1e45be31fa1bf34" => :mountain_lion
    sha1 "b3fbee0555740fe7b0331f9418df807004adf7aa" => :lion
  end

  head "git://git.savannah.gnu.org/bash.git"

  depends_on "readline"

  # Vendor the patches. The mirrors are unreliable for getting the patches,
  # and the more patches there are, the more unreliable they get. Upstream
  # patches can be found in: http://ftpmirror.gnu.org/bash/bash-4.2-patches
  def patches
    # http://article.gmane.org/gmane.comp.shells.bash.bugs/20242
    p = { :p1 => DATA }
    if build.stable?
      p[:p0] = "https://gist.github.com/jacknagel/4008180/raw/1509a257060aa94e5349250306cce9eb884c837d/bash-4.2-001-045.patch"
    end
    p
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with Mac OS X defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end

__END__
diff --git a/parse.y b/parse.y
index b5c94e7..085e5e4 100644
--- a/parse.y
+++ b/parse.y
@@ -5260,9 +5260,16 @@ decode_prompt_string (string)
 #undef ROOT_PATH
 #undef DOUBLE_SLASH_ROOT
 		else
+		  {
 		  /* polite_directory_format is guaranteed to return a string
 		     no longer than PATH_MAX - 1 characters. */
-		  strcpy (t_string, polite_directory_format (t_string));
+                  /* polite_directory_format might simply return the pointer to t_string
+                     strcpy(3) tells dst and src may not overlap, OS X 10.9 asserts this and
+                     triggers an abort trap if that's the case */
+                  temp = polite_directory_format (t_string);
+                  if (temp != t_string)
+                   strcpy (t_string, temp);
+		  }
 
 		temp = trim_pathname (t_string, PATH_MAX - 1);
 		/* If we're going to be expanding the prompt string later,
