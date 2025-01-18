import 'package:functions_framework/serve.dart';
import 'package:isolate_issue/isolate_issue.dart' as function_library;
import 'package:shelf/shelf.dart';

Future<void> main(List<String> args) async {
  await serve(args, _nameToFunctionTarget);
}

FunctionTarget? _nameToFunctionTarget(String name) {
  switch (name) {
    case 'function':
      return FunctionTarget.http(
        function,
      );
    default:
      return null;
  }
}

/// This endpoint, accessible from `<host>/` will fetch from an external API
/// a JSON list and it will respond with a simple string with the
/// amount of current RSS memory.
///
/// It requires the `isolate` query parameter to be set. If true, it will call the external API
/// from a separate isolate. The combination of isolate + external API fetch seems to leak memory.
Future<Response> function(Request request) async {
  final String? withIsolateParam = request.url.queryParameters['isolate'];

  if (withIsolateParam == null ||
      (withIsolateParam != 'true' && withIsolateParam != 'false')) {
    return Response.badRequest(
        body: 'Missing "isolate" query parameter. true/false');
  }

  final bool withIsolate = withIsolateParam == 'true';

  final start = DateTime.now();

  late String resStr;

  try {
    resStr =
        await function_library.fetchResponse(start, withIsolate: withIsolate);
  } catch (e) {
    return Response.internalServerError(body: e.toString());
  }

  return Response.ok(resStr, headers: {
    'Content-Type': 'text/plain',
  });
}
