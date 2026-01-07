FROM dhi.io/alpine-base:3.23-alpine3.23-dev

USER root

# Installs latest Chromium package.
RUN apk upgrade --no-cache --available \
    && apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    && apk add --no-cache chromium nodejs npm tini font-liberation font-dejavu font-noto-emoji

COPY local.conf /etc/fonts/local.conf

# TMP ACL for Marp
RUN mkdir -p /tmp && chmod 1777 /tmp

# Add Chrome as a user
RUN mkdir -p /usr/src/app \
    && adduser -D chrome \
    && chown -R chrome:chrome /usr/src/app

# Run Chrome as non-privileged
USER chrome
WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/chromium

# Autorun chrome headless
ENV CHROMIUM_FLAGS="--headless --disable-gpu --no-sandbox --disable-software-rasterizer --disable-dev-shm-usage"

USER chrome
ENTRYPOINT ["tini", "--"]
