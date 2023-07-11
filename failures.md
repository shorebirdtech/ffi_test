## Failed: tests/ffi/abi_test.dart

Requires fixing to report abi without simulator in the name:
https://github.com/shorebirdtech/shorebird/issues/830

## Failed: tests/ffi/finalizer_external_size_accounting_test.dart

Crash?  OOM in the simulator?
../../runtime/vm/simulator_arm64.cc: 955: error: expected: instr == NULL || reg != R18
Probably worth fixing, but also probably not realistic/blocking.

## Failed: tests/ffi/function_callbacks_many_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_callbacks_structs_by_value_generated_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_callbacks_structs_by_value_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_callbacks_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_callbacks_varargs_generated_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_callbacks_very_many_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_args_native_leaf_test.dart

../../runtime/vm/simulator_arm64.cc: 955: error: expected: instr == NULL || reg != R18
Another oom?


## Failed: tests/ffi/function_structs_by_value_generated_args_native_test.dart

../../runtime/vm/simulator_arm64.cc: 955: error: expected: instr == NULL || reg != R18


## Failed: tests/ffi/function_structs_by_value_generated_args_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_arg_leaf_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_arg_native_leaf_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_arg_native_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_arg_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_leaf_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_native_leaf_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_native_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/function_structs_by_value_generated_ret_test.dart

All function callback tests fail due to:
https://github.com/shorebirdtech/shorebird/issues/829

## Failed: tests/ffi/hardfp_test.dart
## Failed: tests/ffi/regress_44985_test.dart

Compile error?

## Failed: tests/ffi/regress_44986_test.dart

Compile error?

## Failed: tests/ffi/regress_46085_test.dart

Compile error?

## Failed: tests/ffi/regress_47673_2_test.dart

Compile error?

## Failed: tests/ffi/regress_51041_test.dart

Compile error?

## Failed: tests/ffi/regress_51913_test.dart

Compile error?


## Failed: tests/ffi/regress_jump_to_frame_test.dart

CRASH bus error.

## Failed: tests/ffi/stacktrace_regress_37910_test.dart

CRASH bus error.

## Failed: tests/ffi/variance_function_test.dart

CRASH bus error.

## Failed: tests/ffi/vmspecific_function_callbacks_negative_test.dart

Compile error?

## Failed: tests/ffi/vmspecific_function_callbacks_test.dart

CRASH bus error.


## Failed: tests/ffi/vmspecific_function_gc_test.dart

../../runtime/vm/simulator_arm64.cc: 955: error: expected: instr == NULL || reg != R18

## Failed: tests/ffi/vmspecific_handle_test.dart

CRASH, seg fault deallocating handle?

## Failed: tests/ffi/vmspecific_regress_37511_callbacks_test.dart

CRASH
Likely function pointer callback failure.

## Failed: tests/ffi/vmspecific_regress_38993_test.dart

Compile error?

## Failed: tests/ffi/vmspecific_static_checks_ffinative_test.dart

Compile error?

## Failed: tests/ffi/vmspecific_static_checks_test.dart

Compile error?

## Failed: tests/ffi/vmspecific_static_checks_varargs_test.dart

Compile error?

## Failed: tests/ffi/vmspecific_variance_function_checks_test.dart

Compile error?
