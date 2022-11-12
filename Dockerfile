ARG XRAY_VERSION

FROM teddysun/xray:$XRAY_VERSION

WORKDIR /root
COPY start.sh .

ENV TPROXY_PORT 12345
    
ENTRYPOINT [ "/root/start.sh" ]
