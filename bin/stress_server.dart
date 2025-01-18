import 'package:http/http.dart' as http;
import 'package:isolate_issue/args.dart';

// Run with <program> <true|false>
// the argument will decide if the external API call is executed in a separate isolate or not

const String kHost = "http://localhost:8080";

//////////////////////////////////////////////////////

Future<void> main(List<String> args) async {
  final bool withIsolate = parseWithIsolateArg(args);

  while (true) {
    final res = await http.get(Uri.parse("$kHost?isolate=$withIsolate"));
    print("HTTP: ${res.statusCode} - ${res.body}");
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
