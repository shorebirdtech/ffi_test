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

Confirmed in AOT mode:

eseidel@erics-mbp DebugSIMARM64 % ./dart_precompiled_runtime_product /Users/eseidel/Documents/GitHub/dart-sdk/sdk/tests/ffi/function_callbacks_many_test.aot
Simulator hit Unimplemented instruction: at 0x104e952b4, last_pc=0x104e952b0

../../runtime/vm/handles_impl.h: 84: error: expected: thread->MayAllocateHandles()
version=3.0.5 (stable) (Fri Jun 23 13:43:02 2023 -0700) on "macos_simarm64"
pid=14743, thread=16131, isolate_group=main(0x15081fa00), isolate=main(0x150825000)
os=macos, arch=arm64, comp=no, sim=yes
isolate_instructions=105afa840, vm_instructions=105af4000
fp=16b861c00, sp=16b861bd8, pc=104e237d0
  pc 0x0000000104e237d0 fp 0x000000016b861c00 dart::Profiler::DumpStackTrace(void*)+0x68
  pc 0x0000000104b37508 fp 0x000000016b861c20 dart::Assert::Fail(char const*, ...) const+0x28
  pc 0x0000000104cec7e0 fp 0x000000016b861c60 dart::VMHandles::AllocateZoneHandle(dart::Zone*)+0x0
  pc 0x0000000104c48c68 fp 0x000000016b861ca0 dart::Object::HandleImpl(dart::Zone*, dart::ObjectPtr, long)+0x1c
  pc 0x0000000104e93088 fp 0x000000016b862010 dart::SimulatorDebugger::Debug()+0x178
  pc 0x0000000104e96b48 fp 0x000000016b8620e0 dart::Simulator::DezcodePCRel(dart::Instr*)+0xe0
  pc 0x0000000104e94d00 fp 0x000000016b8621c0 dart::Simulator::InstructionDecode(dart::Instr*)+0x188
  pc 0x0000000104e9c6d4 fp 0x000000016b8622c0 dart::Simulator::Execute()+0x80
  pc 0x0000000104e9ca20 fp 0x000000016b8623b0 dart::Simulator::Call(long long, long long, long long, long long, long long, bool, bool)+0x254
  pc 0x0000000104cce8c8 fp 0x000000016b862450 dart::DartEntry::InvokeCode(dart::Code const&, unsigned long, dart::Array const&, dart::Array const&, dart::Thread*)+0x100
  pc 0x0000000104cce6d0 fp 0x000000016b8624c0 dart::DartEntry::InvokeFunction(dart::Function const&, dart::Array const&, dart::Array const&, unsigned long)+0x14c
  pc 0x0000000104cd1674 fp 0x000000016b862530 dart::DartLibraryCalls::HandleMessage(long long, dart::Instance const&)+0x10c
  pc 0x0000000104cf6e3c fp 0x000000016b862cf0 dart::IsolateMessageHandler::HandleMessage(std::__2::unique_ptr<dart::Message, std::__2::default_delete<dart::Message>>)+0x33c
  pc 0x0000000104d09990 fp 0x000000016b862db0 dart::MessageHandler::HandleMessages(dart::MonitorLocker*, bool, bool)+0x1ec
  pc 0x0000000104d0a638 fp 0x000000016b862e40 dart::MessageHandler::TaskCallback()+0x2dc
  pc 0x0000000104eb8a94 fp 0x000000016b862ef0 dart::ThreadPool::WorkerLoop(dart::ThreadPool::Worker*)+0x17c
  pc 0x0000000104eb9354 fp 0x000000016b862f50 dart::ThreadPool::Worker::Main(unsigned long)+0x124
  pc 0x0000000104e1ec70 fp 0x000000016b862fc0 dart::ThreadStart(void*)+0xcc
  pc 0x000000019fffbfa8 fp 0x000000016b862fe0 _pthread_start+0x94
-- End of DumpStackTrace
../../runtime/vm/stack_frame.cc: 357: error: expected: code != Code::null()
Aborting reentrant request for stack trace.
zsh: abort      ./dart_precompiled_runtime_product 


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
