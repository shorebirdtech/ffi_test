import 'dart:ffi';

typedef NativeCallbackTest = Int32 Function(Pointer);
typedef NativeCallbackTestFn = int Function(Pointer);

typedef CallbackFn = Int Function();
int do_callback() {
  print("Hello from Dart");
  return 10;
}

void main() {
  final dylib = DynamicLibrary.open('libhello.so');

  final NativeCallbackTestFn hello_callback =
      dylib.lookupFunction<NativeCallbackTest, NativeCallbackTestFn>(
          "hello_callback",
          isLeaf: false);
  final callback = Pointer.fromFunction<CallbackFn>(do_callback, 20);
  final int callbackResponse = hello_callback(callback);
  print(callbackResponse);
}
