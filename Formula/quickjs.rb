class Quickjs < Formula
  desc "Small And Fast Javascript Engine"
  homepage "https://bellard.org/quickjs/"

  url "https://bellard.org/quickjs/quickjs-2019-07-09.tar.xz"
  sha256 "350c1cd9dd318ad75e15c9991121c80b85c2ef873716a8900f811554017cd564"

  bottle do
    root_url "https://github.com/pinkeen/homebrew-vial/archive"
    cellar :any_skip_relocation
    rebuild 3
    sha256 "3af758daf1c57097f7d52e00479ee5177a72fb70d4294993c8e734014c158a7a" => :mojave
  end

  patch :DATA

  def install
    system "make", "clean"
    system "make", "prefix=#{prefix}", "CONFIG_M32="
    # Tests are dependent on having a TTY, so fake it with `script`
    system "script", "--", "/dev/null", "make", "test", "prefix=#{prefix}", "CONFIG_M32="
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="

    mkdir_p pkgshare
    cp_r "examples", pkgshare
    cp_r "doc", pkgshare
  end

  test do
    assert_match /^QJS42/, shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'")
  end
end

__END__
diff --git a/Makefile b/Makefile.patched
index 7ca93f0..dde78ff 100644
--- a/Makefile
+++ b/Makefile.patched
@@ -120,2 +120,8 @@ endif
 
+# LDFLAGS for building dynamically-loadable JS binary modules
+LDFLAGS_DYNLOAD=$(LDFLAGS)
+ifdef CONFIG_DARWIN
+LDFLAGS_DYNLOAD += -undefined dynamic_lookup
+endif
+
 PROGS=qjs$(EXE) qjsbn$(EXE) qjsc qjsbnc run-test262 run-test262-bn
@@ -370,7 +376,3 @@ doc/%.html: doc/%.texi
 
-ifndef CONFIG_DARWIN
-test: bjson.so
-endif
-
-test: qjs qjsbn
+test: qjs qjsbn bjson.so
 	./qjs tests/test_closure.js
@@ -380,5 +382,3 @@ test: qjs qjsbn
 	./qjs -m tests/test_std.js
-ifndef CONFIG_DARWIN
 	./qjs -m tests/test_bjson.js
-endif
 	./qjsbn tests/test_closure.js
@@ -460,3 +460,3 @@ bench-v8: qjs qjs32
 bjson.so: $(OBJDIR)/bjson.pic.o
-	$(CC) $(LDFLAGS) -shared -o $@ $^ $(LIBS)
+	$(CC) $(LDFLAGS_DYNLOAD) -shared -o $@ $^ $(LIBS)
 
