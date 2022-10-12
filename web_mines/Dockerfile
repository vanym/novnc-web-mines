FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt update && \
    apt install python3 xvfb x11vnc xdemineur -y && \
    apt install git -y && \
    git clone https://github.com/novnc/noVNC.git -b v1.2.0 /root/noVNC && \
    git clone https://github.com/novnc/websockify.git -b v0.10.0 /root/noVNC/utils/websockify && \
    apt purge git -y && \
    apt autoremove -y && \
    ln -sr /root/noVNC/vnc.html /root/noVNC/index.html && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /root

EXPOSE 80

ENTRYPOINT ["/root/entrypoint.sh"]
