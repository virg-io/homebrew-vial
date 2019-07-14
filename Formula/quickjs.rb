class Quickjs < Formula
  desc "QuickJS Javascript Engine"
  homepage "https://bellard.org/quickjs/"

  url "https://bellard.org/quickjs/quickjs-2019-07-09.tar.xz"
  sha256 "350c1cd9dd318ad75e15c9991121c80b85c2ef873716a8900f811554017cd564"

  patch do
    url "../Patches/quickjs/build-dynamic-modules.diff"
    sha256 "3ea7d2641fe4ee3db3dd9c8081266e0269ee21c0fd9f87f798b40891cc61778c"
  end

  def install
    system "make", "prefix=#{prefix}", "CONFIG_M32="
    system "make", "test", "prefix=#{prefix}", "CONFIG_M32="
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="

    mkdir_p pkgshare
    cp_r "examples", pkgshare
  end

  test do
    system "false"
  end
end


__END__
diff --git a/Makefile b/Makefile.patched
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
- $(CC) $(LDFLAGS) -shared -o $@ $^ $(LIBS)
+ $(CC) $(LDFLAGS_DYNLOAD) -shared -o $@ $^ $(LIBS)
