#!/usr/bin/env sh

# disable ip forwarding for better performance
# https://github.com/XTLS/Xray-core/discussions/59

# transparent proxy
# https://xtls.github.io/Xray-docs-next/document/level-2/transparent_proxy/transparent_proxy.html
# https://guide.v2fly.org/app/tproxy.html

ip rule add fwmark 1 table 100 
ip route add local 0.0.0.0/0 dev lo table 100

iptables -t mangle -N XRAY
iptables -t mangle -A XRAY -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A XRAY -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A XRAY -d 255.255.255.255/32 -j RETURN
iptables -t mangle -A XRAY -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
iptables -t mangle -A XRAY -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A XRAY -d 10.0.0.0/8 -p udp ! --dport 53 -j RETURN
iptables -t mangle -A XRAY -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A XRAY -d 172.16.0.0/16 -p udp ! --dport 53 -j RETURN
iptables -t mangle -A XRAY -d 172.16.0.0/16 -j RETURN
iptables -t mangle -A XRAY -m mark --mark 0xff -j RETURN
iptables -t mangle -A XRAY -p udp -j TPROXY --on-ip 127.0.0.1 --on-port 12345 --tproxy-mark 1
iptables -t mangle -A XRAY -p tcp -j TPROXY --on-ip 127.0.0.1 --on-port 12345 --tproxy-mark 1
iptables -t mangle -A PREROUTING -j XRAY

iptables -t mangle -N DIVERT
iptables -t mangle -A DIVERT -j MARK --set-mark 1
iptables -t mangle -A DIVERT -j ACCEPT
iptables -t mangle -I PREROUTING -p tcp -m socket -j DIVERT


# start xray
/usr/bin/xray -config /etc/xray/config.json
