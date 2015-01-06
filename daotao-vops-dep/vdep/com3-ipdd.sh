#!/bin/bash -ex

source config.cfg

echo "Cau hinh hostname cho COMPUTE1 NODE"
sleep 3
echo "VDCITC011103" > /etc/hostname
hostname -F /etc/hostname

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# ADMIN NETWORK
auto eth0
iface eth0 inet static
address $COM3_ADMIN_IP
netmask $NETMASK_ADD
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8

# NIC DATA VM
auto eth2
iface eth2 inet static
address $COM3_DATA_VM_IP
netmask $NETMASK_ADD

EOF

#Khoi dong lai cac card mang vua dat
#service networking restart

#service networking restart
# ifdown eth0 && ifup eth0
# ifdown eth0 && ifup eth0

#sleep 5

init 6
#

