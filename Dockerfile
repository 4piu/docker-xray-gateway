FROM --platform=${TARGETPLATFORM} alpine:latest

ARG TARGETPLATFORM

WORKDIR /root
COPY start.sh install.sh ./

RUN set -ex \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache iptables \
    && mkdir -p /usr/local/share/xray/ \
    && ./install.sh "${TARGETPLATFORM}" \
    && rm ./install.sh

ENV TPROXY_PORT 12345
    
ENTRYPOINT [ "/root/start.sh" ]
