import 'dart:io';

import 'package:path/path.dart' as path;

int compile(String source) {
  final String outFile = path.basenameWithoutExtension(source) + '.aot';

  final dartSdk = '../dart-sdk/sdk'; // Maybe Platform.environment['DART_SDK'];
  final precompiler = path.join(dartSdk, 'pkg/vm/tool/precompiler2');
  final env = Map<String, String>.from(Platform.environment);
  env['DART_CONFIGURATION'] = 'DebugARM64';
  final precompilerArgs = ['--deterministic', source, outFile];
  print('$precompiler ${precompilerArgs.join(' ')}');
  final result =
      Process.runSync(precompiler, precompilerArgs, environment: env);
  if (result.exitCode != 0) {
    print(result.stderr);
    return result.exitCode;
  }
  print("Wrote $outFile");
  return 0;
}

void main(List<String> args) {
  if (args.length < 1) {
    print("Usage: compile.dart <dart files>");
    return;
  }
  for (final source in args) {
    if (compile(source) != 0) {
      print("Compilation failed for $source");
      return;
    }
  }
}
