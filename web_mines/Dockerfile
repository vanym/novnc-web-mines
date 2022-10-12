FROM python:3-alpine

RUN apk add --no-cache bash procps grep xvfb x11vnc xwininfo libxext libxpm \
      imake make gcc musl-dev xorg-cf-files libx11-dev libxpm-dev libxext-dev && \
    cd /root && \
    wget -O xdemineur-2.1.1.tar.gz "http://www.babafou.eu.org/xdemineur/xdemineur-2.1.1.tar.gz" && \
    md5sum -c < <(echo "733daa1db17ed8025186236817c013f7  xdemineur-2.1.1.tar.gz") && \
    tar -vxf xdemineur-2.1.1.tar.gz && \
    cd xdemineur-2.1.1 && \
    xmkmf && \
    make xdemineur && \
    make install && \
    cd /root && \
    rm -rf xdemineur-2.1.1* && \
    apk del -r imake make gcc musl-dev xorg-cf-files libx11-dev libxpm-dev libxext-dev && \
    wget -O novnc-v1.2.0.tar.gz "https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz" && \
    md5sum -c < <(echo "290dfabc4ecdd58d62ccb8c34a922962  novnc-v1.2.0.tar.gz") && \
    tar -vxf novnc-v1.2.0.tar.gz && \
    rm novnc-v1.2.0.tar.gz && \
    ln -s noVNC-1.2.0 noVNC && \
    cd noVNC && \
    ln -s vnc.html index.html && \
    cd /root && \
    wget -O websockify-v0.10.0.tar.gz "https://github.com/novnc/websockify/archive/refs/tags/v0.10.0.tar.gz" && \
    md5sum -c < <(echo "d7abb02f31eb84e136eba8d72bc63fd6  websockify-v0.10.0.tar.gz") && \
    tar -vxf websockify-v0.10.0.tar.gz && \
    rm websockify-v0.10.0.tar.gz && \
    ln -s $(readlink -f websockify-0.10.0) noVNC/utils/websockify

COPY ./entrypoint.sh /root

EXPOSE 80

ENTRYPOINT ["/root/entrypoint.sh"]
