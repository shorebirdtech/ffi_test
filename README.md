## FFI Hacking

Make sure you `gclient sync` after updating from git.

I generally DO NOT trust the Dart build scripts.  They've repeatedly failed
to build all their dependencies correctly for me.

When in doubt, just delete your build directory and build from scratch.

Older versions of the sdk (pre 3.1) seem to build `create_sdk` as part of the
default target, that's no longer the case, we have to explicitly ask ninja
to build it.

Two build directories.  One to house the native-arm64 SDK (no simulator) a
second to force on the simulator, but only build the aot runtime.

```
./tools/build.py --no-goma --mode debug --arch arm64 create_sdk
./tools/build.py --no-goma --mode debug --arch simarm64 --gn-args='dart_force_simulator=true' dart_precompiled_runtime_product
```

## Usage:

Edit `ffi.dart` to change the function you want to call.

Edit `hello.c` to change the C side.

Build C:
```
clang hello.c -shared -o libhello.so
```

```
../dart-sdk/sdk/xcodebuild/DebugARM64/dart-sdk/bin/dart compile aot-snapshot ffi.dart 
```

```
lldb ../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product ffi.aot
```

This is all bundled together in `debug.sh` which you can use.

## FFI Tests

I've just started trying to run the Dart FFI tests.  I couldn't figure
out the Dart test harness, so I wrote a simple harness myself:

`dart run run_ffi_tests.dart`

Or better:

`dart run run_ffi_tests.dart > ffi_tests_output.txt`

And go get some coffee.  It takes a while.
