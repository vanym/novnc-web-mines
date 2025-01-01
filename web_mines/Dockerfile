FROM python:3.13-alpine3.20

RUN apk add --no-cache bash procps grep xvfb x11vnc xwininfo libxext libxpm gcompat \
      dpkg && \
    cd /root && \
    DEBARCH="$(dpkg --print-architecture | awk -F- '{print $NF}')" && \
    wget -O xdemineur_2.1.1-23.deb \
      "https://ftp.debian.org/debian/pool/main/x/xdemineur/xdemineur_2.1.1-23_${DEBARCH}.deb" && \
    dpkg -i --force-architecture --force-depends xdemineur_2.1.1-23.deb && \
    rm -rf xdemineur_2.1.1* && \
    apk del -r dpkg

ENV PATH=/usr/games:$PATH

RUN NOVNC_VERSION=1.5.0 && \
    cd /root && \
    wget -O novnc-v$NOVNC_VERSION.tar.gz "https://github.com/novnc/noVNC/archive/refs/tags/v$NOVNC_VERSION.tar.gz" && \
    md5sum -c < <(echo "7b764b5445ec3e02b0f53913719d1805  novnc-v1.5.0.tar.gz") && \
    tar -vxf novnc-v$NOVNC_VERSION.tar.gz \
      noVNC-$NOVNC_VERSION/vnc.html noVNC-$NOVNC_VERSION/vnc_lite.html noVNC-$NOVNC_VERSION/package.json \
      noVNC-$NOVNC_VERSION/app/ noVNC-$NOVNC_VERSION/core/ noVNC-$NOVNC_VERSION/vendor/ \
      noVNC-$NOVNC_VERSION/utils/novnc_proxy && \
    rm novnc-v$NOVNC_VERSION.tar.gz && \
    ln -sf noVNC-$NOVNC_VERSION noVNC && \
    cd noVNC && \
    ln -sf vnc.html index.html && \
    cd /root && \
    mv -t . noVNC/utils && \
    WEBSOCKIFY_VERSION=0.12.0 && \
    wget -O websockify-v$WEBSOCKIFY_VERSION.tar.gz \
      "https://github.com/novnc/websockify/archive/refs/tags/v$WEBSOCKIFY_VERSION.tar.gz" && \
    md5sum -c < <(echo "08957db4351828bf648bc5e6ae3122fc  websockify-v0.12.0.tar.gz") && \
    tar -vxf websockify-v$WEBSOCKIFY_VERSION.tar.gz && \
    rm websockify-v$WEBSOCKIFY_VERSION.tar.gz && \
    ln -s $(readlink -f websockify-$WEBSOCKIFY_VERSION) utils/websockify

RUN sed -i -e "s/getConfigVar( *'autoconnect' *, *false *)/getConfigVar('autoconnect', true)/" \
      -e "s/Setting( *'reconnect' *, *false *)/Setting('reconnect', true)/" \
      -e "s/initSetting( *'resize' *, *'off' *)/initSetting('resize', 'scale')/" /root/noVNC/app/ui.js

COPY ./entrypoint.sh /root

EXPOSE 80

ENTRYPOINT ["/root/entrypoint.sh"]
