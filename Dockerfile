FROM zenika/alpine-chrome

USER root
RUN apk add --no-cache \
      tini make gcc g++ python3 git nodejs npm yarn font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra
USER chrome
ENTRYPOINT ["tini", "--"]