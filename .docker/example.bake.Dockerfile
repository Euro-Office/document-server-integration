# ==============================================================================
# MODULE DOCKERFILE
# This file is not meant to be built standalone. It is consumed by the 
# docker-bake.hcl files in the parent monorepos.
# ==============================================================================

#### BASE ####
FROM ubuntu:24.04 AS web-base
    RUN apt-get update && \
        apt-get install -y ca-certificates curl gnupg openjdk-21-jdk wget zip brotli bzip2 \
            patch build-essential python3 && \
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
        apt-get install -y nodejs && \
        npm install -g @yao-pkg/pkg grunt-cli && \
        rm -rf /var/lib/apt/lists/*

#### DOCUMENTSERVER-EXAMPLE ####
FROM web-base AS build-example
ARG TARGETARCH

COPY document-server-integration/web/documentserver-example/nodejs/package*.json /app/
RUN --mount=type=cache,target=/root/.npm cd /app && npm install
COPY document-server-integration/web/documentserver-example/nodejs /app
WORKDIR /app
RUN TARGETARCH_PKG=$(echo "$TARGETARCH" | sed 's/amd64/x64/') && \
pkg . -t linux-"$TARGETARCH_PKG" --node-options="--max_old_space_size=4096" -o /app/example

FROM scratch AS example
    COPY --from=build-example /app/ /example