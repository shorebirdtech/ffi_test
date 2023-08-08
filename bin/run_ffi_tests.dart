import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

// Despite reading https://github.com/dart-lang/sdk/wiki/Testing
// I could not find a good way to take a built copy of Dart and a test
// suite and actually run them.  So I wrote my own harness. :sob:

// Generated with find ./tests/ffi/*_test.dart
// Could also just use package:glob.
final tests = [
  'tests/ffi/abi_specific_int_incomplete_aot_test.dart',
  'tests/ffi/abi_specific_int_incomplete_jit_test.dart',
  'tests/ffi/abi_specific_int_test.dart',
  'tests/ffi/abi_test.dart',
  'tests/ffi/aliasing_test.dart',
  'tests/ffi/allocator_test.dart',
  'tests/ffi/bool_test.dart',
  'tests/ffi/c_types_test.dart',
  'tests/ffi/calloc_test.dart',
  'tests/ffi/data_not_asan_test.dart',
  'tests/ffi/data_test.dart',
  'tests/ffi/dylib_isolates_test.dart',
  'tests/ffi/expando_test.dart',
  'tests/ffi/extension_methods_test.dart',
  'tests/ffi/external_typed_data_test.dart',
  'tests/ffi/ffi_callback_unique_test.dart',
  'tests/ffi/ffi_native_test.dart',
  'tests/ffi/finalizer_external_size_accounting_test.dart',
  'tests/ffi/function_callbacks_many_test.dart',
  'tests/ffi/function_callbacks_structs_by_value_generated_test.dart',
  'tests/ffi/function_callbacks_structs_by_value_test.dart',
  'tests/ffi/function_callbacks_test.dart',
  'tests/ffi/function_callbacks_varargs_generated_test.dart',
  'tests/ffi/function_callbacks_very_many_test.dart',
  'tests/ffi/function_structs_by_value_generated_args_leaf_test.dart',
  'tests/ffi/function_structs_by_value_generated_args_native_leaf_test.dart',
  'tests/ffi/function_structs_by_value_generated_args_native_test.dart',
  'tests/ffi/function_structs_by_value_generated_args_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_arg_leaf_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_arg_native_leaf_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_arg_native_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_arg_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_leaf_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_native_leaf_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_native_test.dart',
  'tests/ffi/function_structs_by_value_generated_ret_test.dart',
  'tests/ffi/function_structs_test.dart',
  'tests/ffi/function_test.dart',
  'tests/ffi/function_varargs_generated_leaf_test.dart',
  'tests/ffi/function_varargs_generated_native_leaf_test.dart',
  'tests/ffi/function_varargs_generated_native_test.dart',
  'tests/ffi/function_varargs_generated_test.dart',
  'tests/ffi/function_varargs_name_test.dart',
  'tests/ffi/function_varargs_test.dart',
  'tests/ffi/function_very_many_test.dart',
  'tests/ffi/hardfp_test.dart',
  'tests/ffi/has_symbol_test.dart',
  'tests/ffi/inline_array_multi_dimensional_test.dart',
  'tests/ffi/inline_array_test.dart',
  'tests/ffi/native_effect_test.dart',
  'tests/ffi/negative_function_test.dart',
  'tests/ffi/regress_37254_test.dart',
  'tests/ffi/regress_39044_test.dart',
  'tests/ffi/regress_39063_test.dart',
  'tests/ffi/regress_39885_test.dart',
  'tests/ffi/regress_40537_test.dart',
  'tests/ffi/regress_43016_test.dart',
  'tests/ffi/regress_43693_test.dart',
  'tests/ffi/regress_44985_test.dart',
  'tests/ffi/regress_44986_test.dart',
  'tests/ffi/regress_45189_test.dart',
  'tests/ffi/regress_45198_test.dart',
  'tests/ffi/regress_45507_test.dart',
  'tests/ffi/regress_45988_test.dart',
  'tests/ffi/regress_46004_test.dart',
  'tests/ffi/regress_46085_test.dart',
  'tests/ffi/regress_46127_test.dart',
  'tests/ffi/regress_47594_test.dart',
  'tests/ffi/regress_47673_2_test.dart',
  'tests/ffi/regress_47673_test.dart',
  'tests/ffi/regress_49402_test.dart',
  'tests/ffi/regress_49684_test.dart',
  'tests/ffi/regress_51041_test.dart',
  'tests/ffi/regress_51315_test.dart',
  'tests/ffi/regress_51321_test.dart',
  'tests/ffi/regress_51504_test.dart',
  'tests/ffi/regress_51538_2_test.dart',
  'tests/ffi/regress_51538_3_test.dart',
  'tests/ffi/regress_51538_test.dart',
  'tests/ffi/regress_51913_test.dart',
  'tests/ffi/regress_b_261224444_test.dart',
  'tests/ffi/regress_flutter79441_test.dart',
  'tests/ffi/regress_flutter97301_test.dart',
  'tests/ffi/regress_jump_to_frame_test.dart',
  'tests/ffi/sizeof_test.dart',
  'tests/ffi/snapshot_test.dart',
  'tests/ffi/stacktrace_regress_37910_test.dart',
  'tests/ffi/structs_nested_test.dart',
  'tests/ffi/structs_nnbd_workaround_test.dart',
  'tests/ffi/structs_packed_test.dart',
  'tests/ffi/structs_test.dart',
  'tests/ffi/unaligned_test.dart',
  'tests/ffi/variance_function_test.dart',
  'tests/ffi/vmspecific_dynamic_library_test.dart',
  'tests/ffi/vmspecific_enable_ffi_test.dart',
  'tests/ffi/vmspecific_ffi_native_test.dart',
  'tests/ffi/vmspecific_function_callbacks_exit_test.dart',
  'tests/ffi/vmspecific_function_callbacks_negative_test.dart',
  'tests/ffi/vmspecific_function_callbacks_test.dart',
  'tests/ffi/vmspecific_function_gc_test.dart',
  'tests/ffi/vmspecific_function_test.dart',
  'tests/ffi/vmspecific_handle_dynamically_linked_test.dart',
  'tests/ffi/vmspecific_handle_test.dart',
  'tests/ffi/vmspecific_highmem_32bit_test.dart',
  'tests/ffi/vmspecific_leaf_call_test.dart',
  'tests/ffi/vmspecific_native_finalizer_2_test.dart',
  'tests/ffi/vmspecific_native_finalizer_isolate_groups_test.dart',
  'tests/ffi/vmspecific_native_finalizer_isolates_test.dart',
  'tests/ffi/vmspecific_native_finalizer_test.dart',
  'tests/ffi/vmspecific_object_gc_test.dart',
  'tests/ffi/vmspecific_regress_37100_test.dart',
  'tests/ffi/vmspecific_regress_37511_callbacks_test.dart',
  'tests/ffi/vmspecific_regress_37511_test.dart',
  'tests/ffi/vmspecific_regress_37780_test.dart',
  'tests/ffi/vmspecific_regress_38993_test.dart',
  'tests/ffi/vmspecific_regress_51794_test.dart',
  'tests/ffi/vmspecific_send_port_id_test.dart',
  'tests/ffi/vmspecific_static_checks_ffinative_test.dart',
  'tests/ffi/vmspecific_static_checks_test.dart',
  'tests/ffi/vmspecific_static_checks_varargs_test.dart',
  'tests/ffi/vmspecific_variance_function_checks_test.dart',
];

void main(List<String> args) {
  // Relative to this script's working directory.
  const sdkDir = '../dart-sdk/sdk';
  const compilerConf = 'DebugARM64';
  const runtimeConf = 'DebugSIMARM64';
  final buildDirPath = p.normalize('$sdkDir/xcodebuild/$runtimeConf');

  // Relative to buildDirPath.
  final compilerPath = p.normalize('../../pkg/vm/tool/precompiler2');
  const runtimePath = './dart_precompiled_runtime_product';

  final parser = ArgParser();
  parser
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage and exit')
    ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Verbose output');
  final options = parser.parse(args);

  if (options['help']) {
    print(parser.usage);
    exit(0);
  }

  var testFilter = null;
  if (options.rest.isNotEmpty) {
    testFilter = options.rest[0];
    print('Restricting to tests matching $testFilter');
  }

  for (var test in tests) {
    if (testFilter != null && !test.contains(testFilter)) {
      continue;
    }

    final testPath = p.normalize('../../$test');
    final testBaseName = p.basenameWithoutExtension(test);
    final aotName = '$testBaseName.aot';
    print("Compiling $test");
    if (options['verbose']) {
      print('(cd $buildDirPath && DART_CONFIGURATION=$compilerConf '
          '${compilerPath} ${testPath} ${aotName})');
    }
    final compileResult = Process.runSync(compilerPath, [testPath, aotName],
        workingDirectory: buildDirPath,
        environment: {'DART_CONFIGURATION': compilerConf});

    if (compileResult.exitCode != 0) {
      print(compileResult.stdout);
      print(compileResult.stderr);
      print('Compile Failed: $test');
      continue;
    }

    print("Running $test");
    if (options['verbose']) {
      print('(cd ${buildDirPath} && ${runtimePath} ${aotName})');
    }
    final result =
        Process.runSync(runtimePath, [aotName], workingDirectory: buildDirPath);
    if (result.exitCode != 0) {
      print(result.stdout);
      print(result.stderr);
      print('Failed: $test');
    } else {
      print('Passed: $test');
    }
  }
}
