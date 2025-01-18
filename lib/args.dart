bool parseWithIsolateArg(List<String> args) {
  if (args.isEmpty) {
    argError();
  }
  final withIsolateArg = args.first;
  if (withIsolateArg != 'true' && withIsolateArg != 'false') {
    argError();
  }
  final bool withIsolate = withIsolateArg == 'true';

  return withIsolate;
}

Never argError() {
  throw Exception(
      'Missing "isolate" argument. Pass true/false as first argument');
}
