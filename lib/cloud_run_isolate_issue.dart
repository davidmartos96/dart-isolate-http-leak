import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:shelf/shelf.dart';

Future<Response> function(Request request) async {
  final jsonBody = await computeJsonBody();

  return Response.ok(json.encode(jsonBody), headers: {
    'Content-Type': 'application/json',
  });
}

Future<Map<String, dynamic>> computeJsonBody() async {
  final start = DateTime.now();
  return await Isolate.run(() {
    return {
      'random_string': randomString(7500),
      'start': start.toIso8601String(),
    };
  });
}

List<int> randomList() {
  return List.generate(200, (_) => r.nextInt(100));
}

String randomString(int l) {
  return String.fromCharCodes(List.generate(l, (_) => r.nextInt(100)));
}

final r = Random();
