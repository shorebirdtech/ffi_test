import 'dart:ffi';

// class FlutterView {}

// class PlatformConfiguration {
//   final List<FlutterView> _views = [];
//   FlutterView? get implicitView => _implicitViewEnabled() ? _views[0] : null;

//   @Native<Handle Function()>(
//       symbol: 'PlatformConfigurationNativeApi::ImplicitViewEnabled')
//   external static bool _implicitViewEnabled();
// }

typedef HelloWorldFunc = Bool Function(Bool);
typedef HelloWorld = bool Function(bool);

void main() {
  final dylib = DynamicLibrary.open('libhello.so');
  final HelloWorld hello =
      dylib.lookup<NativeFunction<HelloWorldFunc>>('hello_world').asFunction();

  // print("got: ${PlatformConfiguration().implicitView}");
  final value = hello(true);
  print("Should be false: $value");
  final value2 = hello(false);
  print("Should be true: $value2");
}
