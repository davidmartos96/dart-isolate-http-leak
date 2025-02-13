FROM dart:3.6 AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# old_gen_heap_size is in MB. We want it to run on a small machine
ENV DART_VM_OPTIONS=--old_gen_heap_size=200

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
