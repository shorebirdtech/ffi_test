## FFI Hacking

You'll want our private fork of Dart:
https://github.com/shorebirdtech/dart-sdk/tree/shorebird/dev


#### Contents

1. [Setting up your build environment](#setting-up-your-build-environment)
1. [Getting the sources](#getting-the-sources)
1. [Setting up Visual Studio Code](#setting-up-visual-studio-code)
1. [Building](#building)
1. [Iteration](#iteration)
1. [Tips on debugging](#tips-on-debugging)
1. [FFI tests](#ffi-tests)

### Setting up your build environment

You'll need XCode installed, and the command line tools for XCode.
`xcode-select --install` might help you with that?

I installed XCode from the App Store and then I think it prompted me when
I launched it to install the command line tools?

Flutter has
[some instructions for C++ development](https://github.com/flutter/flutter/wiki/Setting-up-the-Engine-development-environment),
which are provided here for reference (you'll eventually need them, but may not
for just Dart).


### Getting the sources

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


### Setting up Visual Studio Code

At least two extensions provide C++ completion, navigation, highlighting, etc.
for Visual Studio Code (VS Code).  There is the Microsoft C/C++ extension, and
LLVM's clangd extension.  The clangd extension seems to do a better job with
most things and we've been using that one.

It is absolutely essential to get `compile_commands.json` set up for your C++
extension.  Without it you will not have any code completion or
error highlighting.  You will also find that code guarded by `#ifdef` is
incorrectly dimmed and hard to read.

Flutter has
[some instructions](https://github.com/flutter/flutter/wiki/Setting-up-the-Engine-development-environment#vscode-with-cc-intellisense-cc).
Dart is similar.

Ninja can produce a `compile_commands.json` in your build directory.
Build according to the instructions below and additionally pass the flag
`--export-compile-commands` to `build.py`.  The JSON file will be put in the
build directory (e.g., `dart-sdk/sdk/xcodebuild/DebugSIMARM64` on Mac and
`dart-sdk/sdk/out/DebugSIMARM64` on other platforms).

The clangd extension will look for this file in parent directories of the
source code (and subdirectories named `build`, but that doesn't match the Dart
directory structure).  You can copy or symlink the generated file into
`dart-sdk/sdk` or `dart-sdk/sdk/runtime`.

(**Note:** the Microsoft C++ extension does not find `compile_commands.json` in
the same way.  It has a configuration option that contains an absolute path to
the file, so it's not necessary to move it.  Use the VS Code command pallet to
find the C++ configuration UI, expand the "Advanced" section, and provide a
full path to the JSON file.)

You also likely want to use the `sdk.code-workspace` workspace in
the root of the Dart SDK.  Tell VS Code "File > Open Workspace from File...".
This will allow you to open the whole `sdk`` directory while ignoring
enough directories to not make the analyzer crash itself and to silence Dart
code errors and warnings that we don't care about.


### Building

We use two build directories.  One houses the native arm64 AOT compiler and the
other houses the simulator AOT runtime.

This mimics the Shorebird setup where we AOT compile with native tools and run
in the simulator on the device.  It's also slower than necessary to use the
simulator, especially a debug build, to compile.

Build targets needed for AOT compilation, in your Dart SDK checkout directory
(i.e., `dart-sdk/sdk` if you followed the instructions above):

```
./tools/build.py -m debug -a arm64 --no-goma --gn-args='dart_simulator_ffi=true' \
    --gn-args='dart_debug_optimization_level=0' \
    gen_snapshot vm_platform_strong.dill analyze_snapshot
```

The `dart_debug_optimization_level` argument overrides the default -O2.  It's
not needed for `release` or `product` mode bulds.

You might see a warning `directory not found for option -L/usr/local/lib`.
This is Dart [issue 52411](https://github.com/dart-lang/sdk/issues/52411)
and nothing to worry about.

Build targets needed for the AOT runtime:

```
./tools/build.py -m debug -a simarm64 --no-goma --gn-args='dart_force_simulator=true' \
    --gn-args='dart_debug_optimization_level=0' \
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

### Tips on debugging

Both the compiler (`gen_snapshot`) and AOT runtime can dump disassembled
code.  Pass the flags `--disassemble --disassemble-stubs`.  Disassembled code
is written to `stderr` (redirect to a file with `2> /tmp/whatever.asm`).

Assembly code from the compiler has code comments embedded in it by default,
except in `product` builds (pass `--code-comments` to enable).  Assembly code
in the snapshot does not have comments.  If wanted you can find them by:

1. Dump the code from the compiler, with comments
1. Dump the code from the AOT runtime, without comments

The code objects will have different addresses.  Serializing and deserializing
them effectively relocates them.  So you can find an address in the snapshot
code, figure out what code object it is in, and then find the corresponding
code object from the precompiler.

You can trace the simulator.  Pass the flag `--trace-sim-after`.  It takes an
integer value which is the simulated instruction number to begin tracing at.
So for instance, `--trace-sim-after=0` will trace right from the beginning.

If you know that something goes wrong later, for example by running in `lldb`,
you can begin tracing at a later instruction number.  I usually just dump the
entire trace to a file.  Traces are also written to `stderr` so they can be
redirected with `2>`.

You can trace and disassemble at the same time.

Sometimes you will want to change Log::ShouldLogForIsolateGroup to return
true.  The default impl is fine if your failure i son the main isolate, but
if it's before that you will want to return true to catch failures during
startup.

It's often useful to dump registers during Simulator::InstructionDecode
right around where it calls the Disassembler.

### FFI tests

In addition to the compiler and runtime, you'll need to build the supporting
libraries for the FFI tests.

```
./tools/build.py -m debug -a simarm64 --no-goma --gn-args='dart_force_simulator=true' \
  runtime/bin:ffi_test_functions runtime/bin:ffi_test_dynamic_library
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

And go get some coffee.  It takes a while.  You can run individual tests or
a subset of the tests by passing a string argument to the script.  You can pass
the flag `-v` or `--verbose` to the test harness to see what commands it is
running.


### Testing a custom Dart with Flutter

To build your own Dart for local testing with Flutter, we have some
(needlessly private) instructions here:
https://github.com/shorebirdtech/_shorebird/wiki/Hacking-on-the-engine-and-updater

#### Getting the sources

First you have to determine which version of Flutter you're going to use
as your base.  Since you have a specific Dart revision base you're trying to
build into Flutter, you need to figure out what version of Flutter shipped
with that exact Dart revision (or close enough).  In the case of
`shorebird/mixed` it's based on Dart 3.1.0, which was in Flutter 3.13.0.

You can figure out what version of Flutter/Dart your branch is based on by
walking back through `git log` until you find a tag from the flutter team.

We keep Shorebird branches for each Flutter version we ship, so you can
find the branch for the version you're looking for.  In this case it's
`flutter_release/3.13.0` across all of our forks. You only need to check out
the "engine" revision since that contains the DEPS file and `gclient sync` will
check out the other repos for you.

You'll need a checkout of the Flutter engine (documented above), including
making sure you run `gclient sync` with the version of Flutter you're trying to
use.  *After* the gclient sync, you can switch to your Dart branch.

e.g for mixed-mode:
```
cd third_party/dart
git checkout shorebird/mixed-mode
```

I've already done the above as part of a `mixed` branch on the `engine` repo.
It may still be necessary to update the DEPS of that branch to point to the
latest commit in the `shorebird/mixed` branch of the Dart repo and then
`gclient sync` again.

#### Host

Flutter requires a host build to support device builds.  You can build the
host build with your custom Dart, but you'll need to build it with the same
version of Dart that you're trying to use for iOS.

```
./flutter/tools/gn --runtime-mode=release --no-goma
ninja -C out/host_release flutter/build/archives:archive_gen_snapshot
```

I'm not 100% certain which targets are needed to build.  Trying to build all
of the default targets seems to take an hour or more on a modern machine.

archive_gen_snapshot is based on what the host_release builder seems to do:
https://github.com/flutter/engine/blob/main/ci/builders/mac_host_engine.json#L168

#### iOS

Make sure the App you're running is configured to use the Release scheme:
https://github.com/flutter/flutter/wiki/Debugging-the-engine#debugging-ios-builds-with-xcode

To build the engine for iOS with your changes:
```
./flutter/tools/gn --no-goma --runtime-mode=release --no-enable-unittests --ios --gn-arg='dart_force_simulator=true' && \
ninja -C out/ios_release
```

You can try running directly from the command line:
```
flutter run -d iphone --release --local-engine-src-path=$HOME/Documents/GitHub/engine/src --local-engine ios_release -v
```

However you're more likely to want to run inside XCode, where you have easy
access to the debugger:
```
flutter build ios --config-only --local-engine-src-path=$HOME/Documents/GitHub/engine/src --local-engine ios_release
open ios/Runner.xcworkspace
```

However sometimes XCode builds will fail with "Unhandled Exception:" when
there is a failure in one of the Dart scripts which XCode calls out to.
The only way I know to see that error is to use the `flutter run` flavor
of the command with `-v` and then scroll up (the error will occur long before
the actual command execution stops).


### Troubleshooting

"Unexpected Kernel Format Version XXX (expected YYY) when reading file:///...flutter_patched_sdk/platform_strong.dill"
This most often happens when you haven't built `host_release` with the same
version of Dart as you're trying to use for `ios_release`.  Make sure you
`gclient sync` with the same version of Flutter you're trying to use for iOS.


## Linking

Linking is an experimental feature.

You will need analyze_snapshot (built above).

Compile the Dart code to AOT.  We've written a `compile.dart` helper script
to support compiling multiple files at once with the correct flags.

Take two dart files, e.g. `before.dart` and `after.dart`:

```dart
void main() {
    print("Hello before!");
}
```

```dart
void main() {
    print("Hello after!");
    print("And another thing"); // a new call makes the snapshot diff more different.
}
```

Compile them with `compile.dart`:
```
dart compile.dart before.dart after.dart
```

Then run the shorebird linker to link them:
```
dart ../dart-sdk/sdk/pkg/aot_tools/bin/aot_tools.dart link \
  --analyze-snapshot ../dart-sdk/sdk/xcodebuild/DebugARM64/analyze_snapshot \
  --base=before.aot --patch=after.aot
```

It will write out an `after.vmcode` file which contains the two linker tables
one mapping from CPU -> Simulator offsets and the other in reverse with the
after.aot file appended to it.

```
dart ../dart-sdk/sdk/pkg/aot_tools/bin/shorebird_linker.dart before.aot after.aot
Found 3375 base codes and 3375 patch codes
Base size: 819000, patch size: 819016
Hash match found 2648 sharable functions with size 604796
Hash match found 730 sharable leaf functions with size 43180
Subgraph match found 1143 sharable functions with size 72292
No sim offset for cpu offset 0x1cc with hash 8957670f
...
```

```
../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product --base_snapshot=before.aot after.vmcode
Loading failed: Not a 64-bit Mach-O file.
cpu_to_sim[0] = 68 68
sim_to_cpu[0] = 68 68
elf_file_offset = 1c000
Loading failed: Not a 64-bit Mach-O file.
base_snapshot: 0x103c78a40 0x103d57800
base_snapshot: 0x103c78a40 0x103d57800
Hello after!
```

Right now it just prints the table header and first entry, eventually we'll
make it load into the isolate and do the actual linking.


### Mixed Mode testing.

This doesn't really belong here, but it's a convenient place to put it.

```
git checkout  3.1.5
gclient sync
tools/build.py -m debug -a arm64 runtime dart_precompiled_runtime gen_snapshot --no-goma --gn-args='dart_force_simulator=true'
tools/test.py -m debug -c dartkp -r dart_precompiled -a arm64 -p line corelib > mixed_mode_results.txt
```

See mixed_mode_results.txt
