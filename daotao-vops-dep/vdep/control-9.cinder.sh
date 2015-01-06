#!/bin/bash -ex
source config.cfg

apt-get install lvm2 -y

echo "########## Tao Physical Volume va Volume Group (tren disk sdb ) ##########"
fdisk -l
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb

#
echo -e "\e[34m  ######### Cai dat cac goi cho CINDER ##########\e[0m"
sleep 3
apt-get install -y cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms python-cinderclient


echo -e "\e[34m  ######### Cau hinh file cho cinder.conf ##########\e[0m"

filecinder=/etc/cinder/cinder.conf
test -f $filecinder.orig || cp $filecinder $filecinder.orig
rm $filecinder
cat << EOF > $filecinder
[DEFAULT]
rootwrap_config = /etc/cinder/rootwrap.conf
api_paste_confg = /etc/cinder/api-paste.ini
iscsi_helper = tgtadm
volume_name_template = volume-%s
volume_group = cinder-volumes
verbose = True
auth_strategy = keystone
state_path = /var/lib/cinder
lock_path = /var/lock/cinder
volumes_dir = /var/lib/cinder/volumes
rpc_backend = cinder.openstack.common.rpc.impl_kombu
rabbit_host = $CON_ADMIN_IP
rabbit_port = 5672
rabbit_userid = guest
rabbit_password = $RABBIT_PASS
glance_host = $CON_ADMIN_IP
 
[database]
connection = mysql://cinder:$CINDER_DBPASS@$CON_ADMIN_IP/cinder

 
[keystone_authtoken]
auth_uri = http://$CON_ADMIN_IP:5000
auth_host = $CON_ADMIN_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = cinder
admin_password = $CINDER_PASS

EOF

# Phan quyen cho file cinder
chown cinder:cinder $filecinder

echo -e "\e[34m  ######## Dong bo cho cinder ##########\e[0m"
sleep 3
cinder-manage db sync

echo -e "\e[34m  ########## Khoi dong lai CINDER ##########\e[0m"
sleep 3
service cinder-api restart
service cinder-scheduler restart
service cinder-volume restart

echo -e "\e[34m ######### Hoan thanh viec cai dat CINDER ##########\e[0m"

echo -e "\e[92m Chuyen sang thu hien tren NETWORK NODE va COMPUTE NODE \e[0m"
echo -e "\e[92m Sau do quay lai $CON_ADMIN_IP de cai Hoziron\e[0m "
