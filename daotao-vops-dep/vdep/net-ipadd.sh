#!/bin/bash -ex

source config.cfg

# UPDATE Ubuntu
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y

echo "########## Cai dat va cau hinh OpenvSwitch ##########"

apt-get install -y openvswitch-controller openvswitch-switch openvswitch-datapath-dkms

echo "########## Cau hinh br-int va br-ex cho OpenvSwitch ##########"
sleep 5
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth1

echo "########## Cau hinh dia chi IP cho br-ex ##########"

ifaces=/etc/network/interfaces
test -f $ifaces.orig1 || cp $ifaces $ifaces.orig1
rm $ifaces
cat << EOF > $ifaces
# The loopback network interface
auto lo
iface lo inet loopback

# NIC ADMIN
auto eth0
iface eth0 inet static
address $NET_ADMIN_IP
netmask $NETMASK_ADD

# NIC Bridge
auto br-ex
iface br-ex inet static
address $NET_EXT_IP
netmask $NETMASK_ADD_PUB
gateway $GATEWAY_NET
dns-nameservers 8.8.8.8

# NIC External
auto eth1
iface eth1 inet manual
   up ifconfig \$IFACE 0.0.0.0 up
   up ip link set \$IFACE promisc on
   down ip link set \$IFACE promisc off
   down ifconfig \$IFACE down

# NIC DATA VM
auto eth2
iface eth2 inet static
address $NET_DATA_VM_IP
netmask $NETMASK_ADD_VM
EOF

echo "Cau hinh hostname cho NETWORK NODE"
sleep 3
echo "VDCITN3101" > /etc/hostname
hostname -F /etc/hostname

echo "##########  Khoi dong lai may sau khi cau hinh IP Address ##########"
init 6
