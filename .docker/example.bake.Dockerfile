# ==============================================================================
# MODULE DOCKERFILE
# This file is not meant to be built standalone. It is consumed by the 
# docker-bake.hcl files in the parent monorepos.
# ==============================================================================

#### DOCUMENTSERVER-EXAMPLE ####
FROM base AS build-example
ARG TARGETARCH

COPY document-server-integration/web/documentserver-example/nodejs/package*.json /app/
RUN --mount=type=cache,target=/root/.npm cd /app && npm install
COPY document-server-integration/web/documentserver-example/nodejs /app
WORKDIR /app
RUN TARGETARCH_PKG=$(echo "$TARGETARCH" | sed 's/amd64/x64/') && \
pkg . -t linux-"$TARGETARCH_PKG" --node-options="--max_old_space_size=4096" -o /app/example

FROM scratch AS example
    COPY --from=build-example /app/ /example