FROM python:3-alpine

RUN apk add --no-cache bash procps grep xvfb x11vnc xwininfo libxext libxpm gcompat \
      dpkg && \
    cd /root && \
    DEBARCH="$(dpkg --print-architecture | awk -F- '{print $NF}')" && \
    wget -O xdemineur_2.1.1-20.deb \
      "https://ftp.debian.org/debian/pool/main/x/xdemineur/xdemineur_2.1.1-20_${DEBARCH}.deb" && \
    dpkg -i --force-architecture --force-depends xdemineur_2.1.1-20.deb && \
    rm -rf xdemineur_2.1.1* && \
    apk del -r dpkg

ENV PATH /usr/games:$PATH

RUN NOVNC_VERSION=1.3.0 && \
    cd /root && \
    wget -O novnc-v$NOVNC_VERSION.tar.gz "https://github.com/novnc/noVNC/archive/refs/tags/v$NOVNC_VERSION.tar.gz" && \
    md5sum -c < <(echo "22847b4f6e9caa916aa5eceb046f27aa  novnc-v1.3.0.tar.gz") && \
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
    WEBSOCKIFY_VERSION=0.10.0 && \
    wget -O websockify-v$WEBSOCKIFY_VERSION.tar.gz \
      "https://github.com/novnc/websockify/archive/refs/tags/v$WEBSOCKIFY_VERSION.tar.gz" && \
    md5sum -c < <(echo "d7abb02f31eb84e136eba8d72bc63fd6  websockify-v0.10.0.tar.gz") && \
    tar -vxf websockify-v$WEBSOCKIFY_VERSION.tar.gz && \
    rm websockify-v$WEBSOCKIFY_VERSION.tar.gz && \
    ln -s $(readlink -f websockify-$WEBSOCKIFY_VERSION) utils/websockify

COPY ./entrypoint.sh /root

EXPOSE 80

ENTRYPOINT ["/root/entrypoint.sh"]
