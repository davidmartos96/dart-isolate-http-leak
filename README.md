# Error reproduction for the memory leak

Issue: https://github.com/dart-lang/sdk/issues/59937

## Description of the reproduction

The function `fetchResponse` will call an external API using the `http` package and it returns a simple String with the current RSS memory.
It accepts a bool parameter `withIsolate` which will decide if the external API call is executed inside an `Isolate.run` or not.

This leak happens when spawning isolates.


## Reproduce

The repo provides 2 reproduction cases, one running a simple binary which loops calling the function, and another which requests a Dart server to do the work. The latter is how we discovered this leak on our production server.

### To reproduce as CLI:

1. Build the `cli.dart`. `dart compile exe -o bin/cli bin/cli.dart`
2. Run the output with an argument `true` and observe the memory leak. `bin/cli true`. The external fetch will run in an isolate. I've also tried passing `DART_VM_OPTIONS=--old_gen_heap_size=200` as an env variable, but it doesn't make a difference.
3. Run again but with the argument as`false` to see the difference when it doesn't use an isolate.

### To reproduce client/server:

This resembles how we detected the issue on our Dart server. The docker image uses the VM flag `--old_gen_heap_size=200` but it leaks anyway.

1. Build the docker image: `docker build -t dart-isolate-issue --pull .`
2. Run the server: `docker run --rm -p 8080:8080 dart-isolate-issue`
3. Navigate to `https://{HOST}/isolate=true` and `https://{HOST}/isolate=false` to verify it's working.
4. Run the `stress_server.dart` script with an argument `true` and observe the memory leak. It will call the endpoint sequentially and it will trigger the memory leak.
5. Relaunching the docker container is advised before stressing again without the isolate (arg=false), so that the memory is reset.
