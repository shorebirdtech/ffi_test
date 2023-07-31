## FFI Hacking

You'll want our private fork of Dart:
https://github.com/shorebirdtech/dart-sdk/tree/shorebird/dev


### Getting source

These instructions should get you set up? (untested)
```
mkdir dart-sdk
cd dart-sdk
cat > .gclient <<'endmsg'
solutions = [
  {
    "name": "sdk",
    "url": "https://github.com/shorebirdtech/dart-sdk@shorebird/dev",
    "deps_file": "DEPS",
    "managed": False,
    "custom_deps": {},
    "custom_vars": {
      "download_emscripten": True,
    },
  },
]
endmsg
gclient sync
cd sdk
git remote add upstream https://dart.googlesource.com/sdk.git
git fetch upstream
```

### Building

Two build directories.  One to house the native-arm64 SDK (no simulator) a
second to force on the simulator, but only build the aot runtime.

```
./tools/build.py --no-goma --mode debug --arch arm64 create_sdk --gn-args='dart_simulator_ffi=true'
```

```
./tools/build.py --no-goma --mode debug --arch simarm64 --gn-args='dart_force_simulator=true' dart_precompiled_runtime_product
```

### Iteration

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

### FFI Tests

I couldn't figure out the Dart test harness, so I wrote a simple harness myself:

```
dart run run_ffi_tests.dart
```

 Saving results as a baseline in `ffi_tests_output.txt`:

```
dart run run_ffi_tests.dart > ffi_tests_output.txt
```

And go get some coffee.  It takes a while.
