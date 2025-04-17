ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/ash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH
WORKDIR /usr/src

# Install rlwrap
ARG RLWRAP_VERSION
RUN apk add --no-cache --virtual .build-deps \
  build-base \
  readline-dev \
  ncurses-dev \
  && curl -L -s "https://github.com/hanslub42/rlwrap/releases/download/${RLWRAP_VERSION}/rlwrap-${RLWRAP_VERSION}.tar.gz" \
  | tar zxvf - -C /usr/src/ \
  && cd rlwrap-${RLWRAP_VERSION} \
  && ./configure \
  && make \
  && make install \
  && apk del .build-deps \
  && rm -rf /usr/src/*

# Install CLI
ARG CLI_VERSION
RUN curl -Lfso /usr/bin/ha https://github.com/smart-building-manager/cli/releases/download/${CLI_VERSION}/ha_${BUILD_ARCH} \
  && chmod a+x /usr/bin/ha

COPY rootfs /
WORKDIR /
