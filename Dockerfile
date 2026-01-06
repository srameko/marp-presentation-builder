FROM dhi.io/alpine-base:3.22

# Installs latest Chromium package.
RUN apk upgrade --no-cache --available \
    && apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community font-wqy-zenhei \
    && apk add --no-cache chromium-swiftshader ttf-freefont font-noto-emoji tini make gcc g++ python3 git nodejs npm yarn font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra

COPY local.conf /etc/fonts/local.conf

# Add Chrome as a user
RUN mkdir -p /usr/src/app \
    && adduser -D chrome \
    && chown -R chrome:chrome /usr/src/app

# Run Chrome as non-privileged
USER chrome
WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Autorun chrome headless
ENV CHROMIUM_FLAGS="--disable-software-rasterizer --disable-dev-shm-usage"

USER chrome
ENTRYPOINT ["tini", "--"]
