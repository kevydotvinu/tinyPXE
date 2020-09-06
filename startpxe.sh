su - root
vgcreate vgDATA /dev/vdb
lvcreate -n lvLIB -L 5G /dev/vdb
lvcreate -n lvRUN -L 5G /dev/vdb
mkfs -t xfs -n ftype=1 /dev/vgDATA/lvLIB
mkfs -t xfs -n ftype=1 /dev/vgDATA/lvRUN
mount /dev/vgDATA/lvLIB /var/lib/containers
mount /dev/vgDATA/lvRUN /var/run/containers

buildah bud --security-opt label=disable --tag localhost/kevydotvinu/pxe:v1 .
podman run --rm -it --privileged --net host -v "$(pwd)/tftpboot:/var/lib/tftpboot" -v "$(pwd)/dnsmasq.conf.dhcpproxy:/etc/dnsmasq.conf" --security-opt label=disable --name=pxe localhost/kevydotvinu/pxe:v1 --interface=vboxnet0