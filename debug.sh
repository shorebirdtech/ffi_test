clang++ hello.cc -shared -o libhello.so
DART_CONFIGURATION=DebugARM64 ../dart-sdk/sdk/pkg/vm/tool/precompiler2 ffi.dart ffi.aot
lldb ../dart-sdk/sdk/xcodebuild/DebugSIMARM64/dart_precompiled_runtime_product ffi.aot
