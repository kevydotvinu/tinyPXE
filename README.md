# tinyPXE
A containerized PXE server using DNSMASQ.

## Prerequisites packages
```
* buildah
* podman
```

## Usage
### Clone git repository
```bash
git clone https:github.com/kevydotvinu/tinyPXE
cd tinyPXE
```

### Build container image
```bash
buildah bud --security-opt label=disable --tag localhost/kevydotvinu/pxe:v1 .
```

### PXE-enabled Proxy-DHCP Server
A Proxy-DHCP server can be run alongside an existing non-PXE DHCP server. The Proxy-DHCP server provides only the next server and boot filename options, leaving IP allocation to the DHCP server. Clients listen for both DHCP offers and merge the responses as though they had come from one PXE-enabled DHCP server.  
Set `dhcp-range` in `dnsmasq.conf.dhcpproxy`.  
Example: `dhcp-range=192.168.56.0,proxy`. 
```
podman run --rm \
           --interactive \
           --tty \
           --privileged \
           --net host \
           --volume "$(pwd)/tftpboot:/var/lib/tftpboot" \
           --volume "$(pwd)/dnsmasq.conf.dhcpproxy:/etc/dnsmasq.conf" \
           --security-opt label=disable \
           --name pxe localhost/kevydotvinu/pxe:v1 \
           --interface eth0
```

### PXE-enabled DHCP Server
Set `dhcp-range` in `dnsmasq.conf.dhcpserver`.  
Example: `dhcp-range=192.168.56.10,192.168.56.200,12h`
```
podman run --rm \
           --interactive \
           --tty \
           --privileged \
           --net host \
           --volume "$(pwd)/tftpboot:/var/lib/tftpboot" \
           --volume "$(pwd)/dnsmasq.conf.dhcpserver:/etc/dnsmasq.conf" 
           --security-opt label=disable \
           --name pxe localhost/kevydotvinu/pxe:v1 \
           --interface eth0
```
## iPXE manual booting
Press <kbd>Ctrl</kbd> + <kbd>b</kbd> and enter below commands:
```
set net0/filename pxelinux.0
set net0/next-server 192.168.56.X
autoboot
```
