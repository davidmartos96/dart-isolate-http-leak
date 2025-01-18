# Error reproduction

Issue: \_

### To reproduce as CLI:

1. Build the `cli.dart`. `dart compile exe -o bin/cli bin/cli.dart`
2. Run the output with an argument `true` and observe the memory leak. The external fetch will run in an isolate.
3. Run again but with `false` to see the difference.

### To reproduce client/server:

This resembles how we detected the issue on our Dart server. The docker image uses the VM flag `--old_gen_heap_size=200` but it leaks anyway.

1. Build the docker image: `docker build -t dart-isolate-issue --pull .`
2. Run the server: `docker run -p 8080:8080 dart-isolate-issue`
3. Navigate to `https://{HOST}/isolate=true` and `https://{HOST}/isolate=false` to verify it's working.
4. Run the `stress_server.dart` script with an argument `true` and observe the memory leak. It will call the endpoint sequentially and it will trigger the memory leak.
5. Relaunching the docker container is advised before stressing again without the isolate (arg=false), so that the memory is reset.

## Description of the reproduction

The function `fetchResponse` will call an external API using the `http` package and it returns a simple String with the current RSS memory.
It accepts a bool parameter `withIsolate` which will decide if the external API call is executed inside an `Isolate.run` or not.

This leak happens when running on an isolate.
