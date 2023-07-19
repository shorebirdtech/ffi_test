import 'dart:ffi';

typedef NativeCallbackTest = Int32 Function(Pointer);
typedef NativeCallbackTestFn = int Function(Pointer);

typedef CallbackFn = Int Function();

// https://github.com/shorebirdtech/shorebird/issues/829
int do_callback() {
  // Will crash if you uncomment the print.
  // int x = 0;
  // while (x > -1) {
  //   x++;
  // }
  // print("Hello from Dart");
  return 27;
  // return x;
}

int other_callback() {
  return 42;
}

// https://github.com/shorebirdtech/shorebird/issues/654
// int throws_from_dart() {
//   throw Exception("Hello from Dart");
// }

void main() {
  final dylib = DynamicLibrary.open('libhello.so');

  final NativeCallbackTestFn hello_callback =
      dylib.lookupFunction<NativeCallbackTest, NativeCallbackTestFn>(
          "hello_callback",
          isLeaf: false);
  final callback = Pointer.fromFunction<CallbackFn>(do_callback, 20);
  try {
    final int callbackResponse = hello_callback(callback);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }

  final NativeCallbackTestFn callback_two = dylib
      .lookupFunction<NativeCallbackTest, NativeCallbackTestFn>("callback_two",
          isLeaf: false);
  final other = Pointer.fromFunction<CallbackFn>(other_callback, 1242);
  try {
    final int callbackResponse = callback_two(other);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }
}