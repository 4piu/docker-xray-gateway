# docker-xray-gateway
XRay transparent proxy gateway for devices like Playstation and Google Home

## Usage

Assume the docker host is connected to `192.168.1.0/24` through interface `eth0`.

The bypass gateway running xray is going to be `192.168.1.2`, which is an unassigned ip in the LAN.

### Create a macvlan network (bridge network)

```sh
# Syntax:

# docker network create \
# -d macvlan \
# --subnet=<host_subnet> \
# --gateway=<host_gateway> \
# -o parent=<interface> \
# <net_alias>

# Example:

docker network create \
-d macvlan \
--subnet=192.168.1.0/24 \
--gateway=192.168.1.1 \
-o parent=eth0 \
macvlan
```

### Start the container

```sh
# Syntax:

# docker run [-d] \
# --cap-add NET_ADMIN \
# --net=<net_alias> \
# --ip=<container_ip> \
# -v <config_json_file>:/etc/xray/config.json \
# -e TPROXY_PORT=<xray_tproxy_port> \
# d0v0b/xray-gateway

# Example:

docker run -d \
--cap-add NET_ADMIN \
--net=macvlan --ip=192.168.1.2 \
-v /etc/xray/config.json:/etc/xray/config.json \
-e TPROXY_PORT=12345 \
d0v0b/xray-gateway
```

`TPROXY_PORT` should match your xray configuration file.

### Manually configure the device

Set the gateway of the device to `192.168.1.2` and all its traffic should be proxied.


## Remove

### Remove the network

```sh
docker network rm macvlan
```

## Example configuration

[Example configuration](https://xtls.github.io/document/level-2/tproxy.html)

In your configuration, set mark=255 (0xff) in [SockoptObject](https://www.v2ray.com/chapter_02/05_transport.html#sockoptobject) for all outbound traffic. 
