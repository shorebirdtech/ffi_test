## FFI Hacking

You'll want our private fork of Dart:
https://github.com/shorebirdtech/dart-sdk/tree/shorebird/dev


### Setting up your build environment

You'll need XCode installed, and the command line tools for XCode.
`xcode-select --install` might help you with that?

I installed XCode from the App Store and then I think it prompted me when
I launched it to install the command line tools?

Flutter has some instructions for C++ development, which I provide here for
reference (you'll eventually need them, but may not for just Dart):
https://github.com/flutter/flutter/wiki/Setting-up-the-Engine-development-environment


### Getting source

Dart has some public docs which may help:
https://github.com/dart-lang/sdk/wiki/Building

It's *much* faster to use Google's servers to get Dart first, and then
switch to our fork.  GitHub is very slow at cloning the Dart repo.

Still this whole process may take 20+ minutes to run.

```
mkdir dart-sdk
cd dart-sdk
fetch dart
cd sdk
git remote rename origin upstream
git remote add origin https://github.com/shorebirdtech/dart-sdk.git
git fetch
git checkout origin/shorebird/dev
gclient sync -D
```

The -D isn't necessary in the `gclient sync` it's just there to clean up
the empty directories from dependencies that `main` dart has but our
fork of `stable` (3.0.6 at time of writing) doesn't yet.

### Building

Two build directories.  One to house the native-arm64 SDK (no simulator) a
second to force on the simulator, but only build the aot runtime.

We do this because it's very slow to use the simulator build and creating
the whole sdk (possibly unecessary) involves compiling Dart code which
when done in the simulator is very slow.

It may be possible to cut down the list of targets further and combine to a
single build directory (or otherwise speed up the build) now that we're
to a mostly working state.

```
./tools/build.py --no-goma --mode debug --arch arm64 create_sdk --gn-args='dart_simulator_ffi=true'
./tools/build.py --no-goma --mode debug --arch simarm64 --gn-args='dart_force_simulator=true' dart_precompiled_runtime_product
```

This also takes a while to run the first time.  Probably ~5-10 mins and your
fan will spin up.

### Iteration

Edit `ffi.dart` to change the function you want to call.

Edit `hello.cc` to change the C/C++ side.

`debug.sh` is a pre-made script to do this for you.

By hand you can, build C:
```
clang++ hello.cc -shared -o libhello.so
```

Compile the Dart code to AOT:
```
../dart-sdk/sdk/xcodebuild/DebugARM64/dart-sdk/bin/dart compile aot-snapshot ffi.dart 
```

Run the AOT snapshot in lldb:
```
lldb ../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product ffi.aot
```

### FFI Tests

You'll need to build both the runtime and the supporting libraries for the FFI tests.

```
./tools/build.py --no-goma --mode debug --arch simarm64 --gn-args='dart_force_simulator=true' dart_precompiled_runtime_product runtime
```

Then you can run the tests.

I couldn't figure out the Dart test harness, so I wrote a simple harness myself.

My test harness has no concept of "expected failure" tests, some of the tests
are "compile failure" tests so they will fail.  We could just remove them
from the list of tests to run, but I haven't yet.

```
dart run run_ffi_tests.dart
```

Saving results as a baseline in `ffi_tests_output.txt`:

```
dart run run_ffi_tests.dart > ffi_tests_output.txt
```

And go get some coffee.  It takes a while.
