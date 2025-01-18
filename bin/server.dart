import 'package:functions_framework/serve.dart';
import 'package:cloud_run_isolate_issue/cloud_run_isolate_issue.dart'
    as function_library;

Future<void> main(List<String> args) async {
  await serve(args, _nameToFunctionTarget);
}

FunctionTarget? _nameToFunctionTarget(String name) {
  switch (name) {
    case 'function':
      return FunctionTarget.http(
        function_library.function,
      );
    default:
      return null;
  }
}
