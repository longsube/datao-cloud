#!/bin/bash -ex
#
source config.cfg

echo -e "\e[34m ########## CAI DAT NOVA TREN $CON_ADMIN_IP ##########\e[0m"
sleep 5 
apt-get -y install nova-api nova-cert nova-conductor nova-consoleauth nova-scheduler python-novaclient

######## SAO LUU CAU HINH cho NOVA ##########"
sleep 7

#
controlnova=/etc/nova/nova.conf
test -f $controlnova.orig || cp $controlnova $controlnova.orig
rm $controlnova
touch $controlnova
cat << EOF >> $controlnova
[DEFAULT]
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/var/lock/nova
force_dhcp_release=True
iscsi_helper=tgtadm
libvirt_use_virtio_for_bridges=True
connection_type=libvirt
root_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf
verbose=True
ec2_private_dns_show_ip=True
api_paste_config=/etc/nova/api-paste.ini
volumes_path=/var/lib/nova/volumes
enabled_apis=ec2,osapi_compute,metadata
auth_strategy = keystone

# Dat Quota cho Project
quota_instances=9999
quota_volumes=9999
quota_injected_files=9999
quota_cores=9999

# Khai bao cho RABBITMQ
rpc_backend = rabbit
rabbit_host = $CON_ADMIN_IP
rabbit_password = $RABBIT_PASS

# Cau hinh cho VNC
#my_ip = $CON_ADMIN_IP
#vncserver_listen = $CON_ADMIN_IP
#vncserver_proxyclient_address = $CON_ADMIN_IP

# Tu dong Start VM khi reboot OpenStack
resume_guests_state_on_host_boot=True

# Cho phep thay doi kich thuoc may ao
allow_resize_to_same_host=True
scheduler_default_filters=AllHostsFilter

# Cho phep chen password khi khoi tao
libvirt_inject_password = True
libvirt_inject_partition = -1
enable_instance_password = True


network_api_class = nova.network.neutronv2.api.API
neutron_url = http://$CON_ADMIN_IP:9696
neutron_auth_strategy = keystone
neutron_admin_tenant_name = service
neutron_admin_username = neutron
neutron_admin_password = $NEUTRON_PASS
neutron_admin_auth_url = http://$CON_ADMIN_IP:35357/v2.0
linuxnet_interface_driver = nova.network.linux_net.LinuxOVSInterfaceDriver
firewall_driver = nova.virt.firewall.NoopFirewallDriver
security_group_api = neutron
service_neutron_metadata_proxy = true
neutron_metadata_proxy_shared_secret = $METADATA_SECRET

[database]
connection = mysql://nova:$NOVA_DBPASS@$CON_ADMIN_IP/nova

[keystone_authtoken]
auth_uri = http://$CON_ADMIN_IP:5000
auth_host = $CON_ADMIN_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = nova
admin_password = $NOVA_PASS
EOF

echo -e "\e[34m  ########## XOA FILE DB MAC DINH ##########\e[0m"
sleep 7
rm /var/lib/nova/nova.sqlite

echo -e "\e[34m ########## DONG BO DB CHO NOVA ##########\e[0m"
sleep 7 
nova-manage db sync

# fix loi libvirtError: internal error: no supported architecture for os type 'hvm'
echo 'kvm_intel' >> /etc/modules

echo -e "\e[34m ########## KHOI DONG LAI NOVA ##########\e[0m"
sleep 7 
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
#service nova-novncproxy restart
sleep 7 

echo -e "\e[34m########## KHOI DONG NOVA LAN 2 ##########\e[0m"
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
#service nova-novncproxy restart

echo "########## KIEM TRA LAI DICH VU NOVA ##########"
nova-manage service list

echo -e "\e[92m Thuc thi lenh duoi \e[0m"
echo -e "\e[92m bash control-8.neutron.sh \e[0m"