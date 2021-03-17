# docker-xray-gateway
XRay gateway for devices like Playstation and Google Home

## Usage

Assume the host is connected to `192.168.1.0/24` through interface `eth0`. 

The bypass gateway is going to be `192.168.1.2`, which is an unused ip in LAN. 

### Create a macvlan network

```sh
# docker network create -d macvlan --subnet=<host_subnet> --gateway=<host_gateway> -o parent=<interface> <net_alias>

docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macvlan
```

### Start the container

```sh
# docker run [-d] --cap-add NET_ADMIN --net=<net_alias> --ip=<container_ip> -v <config_json_file>:/etc/xray/config.json -e TPROXY_PORT=<xray_tproxy_port> d0v0b/xray-gateway

docker run -d --cap-add NET_ADMIN --net=macvlan --ip=192.168.1.2 -v /etc/xray/config.json:/etc/xray/config.json -e TPROXY_PORT=12345 d0v0b/xray-gateway
```

`TPROXY_PORT` should match your configuration. 

### Manually configure the device

On the Playstation, for example, set the gateway to `192.168.1.2` and all its traffic should be proxied. 


## Remove

### Remove the network

```sh
docker network rm macvlan
```

## Example configuration

[Example configuration](https://xtls.github.io/documents/level-2/tproxy/)


In your configuration, set mark=2 in [SockoptObject](https://www.v2ray.com/chapter_02/05_transport.html#sockoptobject) for all outbound traffic or it will be looped back. 
