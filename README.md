# tinyPXE
A containerized PXE server using Dnsmasq.

## Prerequisites packages
```bash
* buildah
* podman
```

## Configure container storage (Optional)
```bash
su - root
vgcreate vgDATA /dev/vdb
lvcreate -n lvLIB -L 5G /dev/vdb
lvcreate -n lvRUN -L 5G /dev/vdb
mkfs -t xfs -n ftype=1 /dev/vgDATA/lvLIB
mkfs -t xfs -n ftype=1 /dev/vgDATA/lvRUN
mount /dev/vgDATA/lvLIB /var/lib/containers
mount /dev/vgDATA/lvRUN /var/run/containers
```

## Usage
### Open firewall port
```bash
firewall-cmd --add-service=tftp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --add-port=4011/udp --permanent
firewall-cmd --reload
```

### Clone git repository
```bash
git clone https:github.com/kevydotvinu/tinyPXE
cd tinyPXE
```

### Build container image
```bash
buildah bud --security-opt label=disable --tag localhost/kevydotvinu/tinypxe:v1 .
```

### Build undionly.kpxe with script embedded
```bash
yum install -y xz-devel
yum groupinstall "Development Tools"
git clone git://git.ipxe.org/ipxe.git
cd ipxe/src
make bin/undionly.kpxe EMBED=../../tftpboot/boot.ipxe
cp bin/undionly.kpxe ../../tftpboot/
chmod 664 ../../tftpboot/undionly.kpxe
```

### PXE-enabled Proxy-DHCP Server
A Proxy-DHCP server can be run alongside an existing non-PXE DHCP server. The Proxy-DHCP server provides only the next server and boot filename options, leaving IP allocation to the DHCP server. Clients listen for both DHCP offers and merge the responses as though they had come from one PXE-enabled DHCP server.  

```bash
podman run --rm \
           --interactive \
           --tty \
           --privileged \
           --net host \
           --volume "$(pwd)/boot.ipxe:/var/lib/tftpboot/boot.ipxe" \
           --volume "$(pwd)/default:/var/lib/tftpboot/pxelinux.cfg/default" \
           --volume "$(pwd)/dnsmasq.conf.dhcpproxy:/etc/dnsmasq.conf" \
           --security-opt label=disable \
           --name tinypxe localhost/kevydotvinu/tinypxe:v1 \
           --interface eth0
```
To run the pod in background, replate --rm, --interactive and --tty with --detach.

### PXE-enabled DHCP Server
```bash
podman run --rm \
           --interactive \
           --tty \
           --privileged \
           --net host \
           --volume "$(pwd)/boot.ipxe:/var/lib/tftpboot/boot.ipxe" \
           --volume "$(pwd)/default:/var/lib/tftpboot/pxelinux.cfg/default" \
           --volume "$(pwd)/dnsmasq.conf.dhcpserver:/etc/dnsmasq.conf" 
           --security-opt label=disable \
           --name tinypxe localhost/kevydotvinu/tinypxe:v1 \
           --interface eth0
```
To run the pod in background, replate --rm, --interactive and --tty with --detach.

## iPXE manual booting
Press <kbd>Ctrl</kbd> + <kbd>b</kbd> and enter below commands:
```bash
set net0/filename pxelinux.0
set net0/next-server 192.168.X.X
autoboot
```
