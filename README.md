## FFI Hacking

Make sure you `gclient sync` after updating from git.

I generally DO NOT trust the Dart build scripts.  They've repeatedly failed
to build all their dependencies correctly for me.

When in doubt, just delete your build directory and build from scratch.

Two build direcories:

```
./tools/build.py --no-goma --mode debug --arch arm64  
./tools/build.py --no-goma --mode debug --arch simarm64 dart_precompiled_runtime_product
```

# Usage:

Edit `ffi.dart` to change the function you want to call.

Edit `hello.c` to change the C side.

Use `clang hello.c -shared -o libhello.so` to build the C side.

```
../dart-sdk/sdk/xcodebuild/DebugARM64/dart-sdk/bin/dart compile aot-snapshot ffi.dart 
```

```
lldb ../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product ffi.aot
```