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

### Setting up VSCode

It is absolutely essential to get compile_commands.json set up for VSC
without it you will not have any code completion or error highlighting.

https://github.com/flutter/flutter/wiki/Setting-up-the-Engine-development-environment#vscode-with-cc-intellisense-cc
Has some instructions for Flutter.  Dart is similar.  ninja should
produce a compile_commands.json in your build directory, you just need
to either symlink it to the root of your project, copy it to the root,
or set the `"compileCommands"` setting in your `.vscode/settings.json`
to point to the file.

You won't be able to do this until you build Dart once.

You also likely want to use the sdk.code-workspace workspace in
Dart.  It will allow you to open the whole sdk/ directory while ignoring
enough directories to not make the analyzer crash itself.


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

We use two build directories.  One houses the native arm64 AOT compiler and the
other houses the simulator AOT runtime.

This mimics the Shorebird setup where we AOT compile with native tools and run
in the simulator on the device.  It's also slower than necessary to use the
simulator, especially a debug build, to compile.

Build targets needed for AOT compilation:

```
./tools/build.py -m debug -a arm64 --no-goma --gn-args='dart_simulator_ffi=true' \
    gen_snapshot vm_platform_strong.dill
```

You might see a warning `directory not found for option -L/usr/local/lib`.
This is Dart [issue 52411](https://github.com/dart-lang/sdk/issues/52411)
and nothing to worry about.

Build targets needed for the AOT runtime:

```
./tools/build.py -m debug -a simarm64 --no-goma --gn-args='dart_simulator_ffi=true' \
    dart_precompiled_runtime_product
```

### Iteration

Edit `ffi.dart` to change the function you want to call.

Edit `hello.cc` to change the C/C++ side.

`debug.sh` is a pre-made script to compile and start `lldb` with the AOT snapshot binary.

By hand you can, build C:
```
clang++ hello.cc -shared -o libhello.so
```

Compile the Dart code to AOT:
```
DART_CONFIGURATION=DebugARM64 ../dart-sdk/sdk/pkg/vm/tool/precompiler2 ffi.dart ffi.aot
```

Run the AOT snapshot in lldb:
```
lldb ../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product ffi.aot
```

### FFI Tests

In addition to the compiler and runtime, you'll need to build the supporting
libraries for the FFI tests.

```
./tools/build.py -m debug -a simarm64 --no-goma --gn-args='dart_force_simulator=true' \
  runtime/bin:ffi_test_functions
```

Then you can run the tests.

We couldn't figure out how to make the Dart test harness use different
configurations for the AOT compiler and runtime, so we wrote a simple harness
ourselves.

The test harness has no concept of "expected failure" tests, some of the tests
are "compile failure" tests so they will fail.  We could just remove them
from the list of tests to run, but we haven't yet.

```
dart run bin/run_ffi_tests.dart
```

Saving results as a baseline in `ffi_tests_output.txt`:

```
dart run run_ffi_tests.dart > ffi_tests_output.txt
```

And go get some coffee.  It takes a while.  You can pass the flag `-v` or
`--verbose` to the test harness to see what commands it is running.
