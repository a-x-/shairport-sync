FROM alpine

ARG SHAIRPORT_VERSION=master
ARG ALAC_VERSION=master

RUN apk --no-cache add \
        git build-base autoconf automake \
        libtool libstdc++ \
        libdaemon libdaemon-dev \
        popt popt-dev \
        libconfig libconfig-dev \
        alsa-lib alsa-lib-dev \
        avahi-libs avahi-dev \
        openssl openssl-dev \
    && cd /tmp \
    && git clone -b $ALAC_VERSION --depth=1 --single-branch https://github.com/mikebrady/alac.git \
      && cd alac \
    && autoreconf -fi \
    && ./configure \
    && make \
    && make install \
    && ldconfig / \
    && cd /tmp \
    && git clone -b $SHAIRPORT_VERSION --depth=1 --single-branch https://github.com/mikebrady/shairport-sync.git \
      && cd shairport-sync \
    && autoreconf -i -f  \
    && ./configure \
	--with-alsa \
	--with-avahi \
	--with-pipe \
	--with-ssl=openssl \
	--with-metadata \
	--with-apple-alac \
	--with-mqtt-client \
    && make \
    && make install \
    && cd \
    && apk del \
        git \
        build-base autoconf automake \
        libdaemon-dev \
        popt-dev \
        libconfig-dev \
        alsa-lib-dev \
        avahi-dev \
        openssl-dev \
    && apk --no-cache add \
        dbus \
        alsa-lib \
        libdaemon \
        popt \
        openssl \
        avahi \
        libconfig \
    && rm -rf \
        /tmp/alac \
        /tmp/shairport-sync \
        /lib/apk/db/* \
        /etc/ssl \
        /usr/local/etc/shairport-sync*

COPY start.sh /start.sh

COPY shairport-sync.conf /usr/local/etc/shairport-sync.conf

RUN chmod a+x /start.sh

ENTRYPOINT [ "/start.sh" ]
