ARG ALPINE_VERSION=3.23.4

FROM alpine:${ALPINE_VERSION} AS build

ARG NETBOOT_XYZ_WEBAPP_VERSION

RUN apk add --no-cache curl npm \
    && mkdir /app \
    && curl -o /tmp/webapp.tar.gz -L "https://github.com/netbootxyz/webapp/archive/${NETBOOT_XYZ_WEBAPP_VERSION}.tar.gz" \
    && tar xf /tmp/webapp.tar.gz -C /app/ --strip-components=1 \
    # Install only production dependencies
    && cd /app \
    && npm install --omit=dev --no-audit --no-fund \
    # Upgrade systeminformation to fix CVE-2025-68154, CVE-2026-26280, CVE-2026-26318
    && npm install systeminformation@5.31.0 --omit=dev --no-audit --no-fund --save \
    # Clean up build artifacts and cache
    && npm cache clean --force \
    && rm -rf /tmp/* 

# Production stage - Final container
FROM alpine:${ALPINE_VERSION}
RUN apk add --no-cache \
    tini bash curl jq zlib \
    nodejs npm \
    && mkdir -p /app /config /assets /defaults

ENV WEB_APP_PORT='3000' \
    NODE_ENV='production' \
    NPM_CONFIG_CACHE='/tmp/.npm'

COPY --from=build /app /app

EXPOSE 3000

VOLUME /config
VOLUME /assets

# Copy configuration files and scripts
COPY entrypoint.sh /

# Make scripts executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

