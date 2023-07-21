clang++ hello.cc -shared -o libhello.so
../dart-sdk/sdk/xcodebuild/DebugARM64/dart-sdk/bin/dart compile aot-snapshot ffi.dart
lldb ../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product ffi.aot