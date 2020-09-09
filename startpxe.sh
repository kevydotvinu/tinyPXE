### Run a PXE container
su - root
vgcreate vgDATA /dev/vdb
lvcreate -n lvLIB -L 5G /dev/vdb
lvcreate -n lvRUN -L 5G /dev/vdb
mkfs -t xfs -n ftype=1 /dev/vgDATA/lvLIB
mkfs -t xfs -n ftype=1 /dev/vgDATA/lvRUN
mount /dev/vgDATA/lvLIB /var/lib/containers
mount /dev/vgDATA/lvRUN /var/run/containers

firewall-cmd --add-port=4011/udp --permanent
firewall-cmd --add-port=67/udp --permanent
firewall-cmd --add-port=69/udp --permanent
firewall-cmd --reload

buildah bud --security-opt label=disable --tag localhost/kevydotvinu/pxe:v1 .
podman run --rm -it --privileged --net host -v "$(pwd)/tftpboot:/var/lib/tftpboot" -v "$(pwd)/dnsmasq.conf.dhcpproxy:/etc/dnsmasq.conf" --security-opt label=disable --name=pxe localhost/kevydotvinu/pxe:v1 --interface=vboxnet0

### iPXE commands
Ctrl+b
set net0/filename pxelinux.0
set net0/next-server X.X.X.X
autoboot

### Build undionly.kpxe with script embedded
yum install -y xz-devel.x86_64
git clone git://git.ipxe.org/ipxe.git
cd ipxe/src
cat << EOF > boot.ipxe
#!ipxe

menu install menu
item ubuntu Ubuntu install
item centos7 Centos7 install
item --gap
item back install menu
choose --timeout 20000 --default back target && goto ${target} || goto menu

:ubuntu
set ubuntu http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64
initrd ${ubuntu}/initrd.gz
kernel ${ubuntu}/linux tasks=standard vga=788 -- quiet
boot

:centos7
set centos7 http://mirror.centos.org/centos/7/os/x86_64
initrd ${centos7}/image/pxeboot/initrd.img
kernel ${centos7}/image/pxeboot/vmlinuz vga=788 repo=${centos7}
boot

:back
exit
EOF
make bin/undionly.kpxe EMBED=boot.ipxe
cp bin/undionly.kpxe tftpboot/
