FROM python:3-slim-buster

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    apt install wget xvfb x11vnc x11-utils xdemineur -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /usr/games:$PATH

SHELL ["bash", "-c"]

RUN NOVNC_VERSION=1.2.0 && \
    cd /root && \
    wget -O novnc-v$NOVNC_VERSION.tar.gz "https://github.com/novnc/noVNC/archive/refs/tags/v$NOVNC_VERSION.tar.gz" && \
    md5sum -c < <(echo "290dfabc4ecdd58d62ccb8c34a922962  novnc-v1.2.0.tar.gz") && \
    tar -vxf novnc-v$NOVNC_VERSION.tar.gz \
      noVNC-$NOVNC_VERSION/vnc.html noVNC-$NOVNC_VERSION/vnc_lite.html noVNC-$NOVNC_VERSION/package.json \
      noVNC-$NOVNC_VERSION/app/ noVNC-$NOVNC_VERSION/core/ noVNC-$NOVNC_VERSION/vendor/ \
      noVNC-$NOVNC_VERSION/utils/launch.sh && \
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
