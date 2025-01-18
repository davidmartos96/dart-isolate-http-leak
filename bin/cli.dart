import 'package:isolate_issue/args.dart';
import 'package:isolate_issue/isolate_issue.dart';

// Run with <program> <true|false>
// the argument will decide if the external API call is executed in a separate isolate or not
Future<void> main(List<String> args) async {
  final bool withIsolate = parseWithIsolateArg(args);

  while (true) {
    final res = await fetchResponse(DateTime.now(), withIsolate: withIsolate);
    print(res);
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
