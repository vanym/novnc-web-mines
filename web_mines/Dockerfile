FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install python3 xvfb x11vnc xdemineur -y && \
    apt install git -y && \
    git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify.git /noVNC/utils/websockify && \
    apt purge git -y && \
    apt autoremove -y && \
    ln -sr /noVNC/vnc.html /noVNC/index.html && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
