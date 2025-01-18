import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

Future<String> fetchResponse(
  DateTime start, {
  required bool withIsolate,
}) async {
  if (withIsolate) {
    return await Isolate.run(() => _fetchResInner(start, isIsolate: true));
  } else {
    return await _fetchResInner(start, isIsolate: false);
  }
}

Future<String> _fetchResInner(DateTime start, {required bool isIsolate}) async {
  final http.Response externalApiRes;
  try {
    final apiURL = "https://cache-test.skilldevs.com/sample-json.json";
    externalApiRes = await http.get(Uri.parse(apiURL));
    if (externalApiRes.statusCode != 200) {
      throw Exception("Invalid status code ${externalApiRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Failed to fetch data: $e");
  }

  final apiData = json.decode(externalApiRes.body) as List<dynamic>;

  return "WITH ISOLATE: $isIsolate - Num posts: ${apiData.length} at $start. RSS: ${bytesStr(ProcessInfo.currentRss)}";
}

String bytesStr(int bytes) {
  if (bytes < 1024) {
    return "$bytes B";
  } else if (bytes < 1024 * 1024) {
    return "${(bytes / 1024).toStringAsFixed(2)} KB";
  } else {
    return "${(bytes / 1024 / 1024).toStringAsFixed(2)} MB";
  }
}
