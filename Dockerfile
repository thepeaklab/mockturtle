# You can set the Swift version to what you need for your app. Versions can be found here: https://hub.docker.com/_/swift
FROM swift:4.2 as builder

RUN apt-get -qq update && apt-get -q -y install \
  tzdata \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# Production image
FROM ubuntu:16.04
RUN apt-get -qq update && apt-get install -y \
  libicu55 libxml2 libbsd0 libcurl3 libatomic1 \
  tzdata \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /build/bin/Run .
COPY --from=builder /build/lib/* /usr/lib/
COPY --from=builder /app/Public ./Public
# Uncommand the next line if you are using Leaf
#COPY --from=builder /app/Resources ./Resources

COPY Scripts/entrypoint-serve.sh /usr/local/bin/
COPY Scripts/entrypoint-generate-scenario-file.sh /usr/local/bin/

ENV ENV prod
ENV HOSTNAME 0.0.0.0
ENV PORT 8080
ENV FOLDER .
ENV OUTPUT_FILE output.json

ENTRYPOINT ["entrypoint-generate-scenario-file.sh"]
