# tinyPXE
A tiny PXE server using DNSMASQ

#### Prerequisites
```
* buildah
* podman
```

#### Usage
```
### Clone git repository
git clone https:github.com/kevydotvinu/tinyPXE
cd tinyPXE

### Build container image
buildah bud --security-opt label=disable --tag localhost/kevydotvinu/pxe:v1 .

### PXE Proxy
podman run --rm -it --privileged --net host -v "$(pwd)/tftpboot:/var/lib/tftpboot" -v "$(pwd)/dnsmasq.conf.dhcpproxy:/etc/dnsmasq.conf" --security-opt label=disable --name=pxe localhost/kevydotvinu/pxe:v1 --interface=eth0

### PXE DHCP Server
podman run --rm -it --privileged --net host -v "$(pwd)/tftpboot:/var/lib/tftpboot" -v "$(pwd)/dnsmasq.conf.dhcpserver:/etc/dnsmasq.conf" --security-opt label=disable --name=pxe localhost/kevydotvinu/pxe:v1 --interface=eth0
```
