#!/bin/bash -ex
#

source config.cfg

SERVICE_ID=`keystone tenant-get service | awk '$2~/^id/{print $4}'`


echo -e "\e[34m  ########## CAI DAT NEUTRON TREN $CON_ADMIN_IP############ \e[0m"
sleep 5
apt-get -y install neutron-server neutron-plugin-ml2

######## SAO LUU CAU HINH NEUTRON.CONF CHO $CON_ADMIN_IP##################"
echo "########## SUA FILE CAU HINH  NEUTRON CHO $CON_ADMIN_IP ##########"
sleep 7

#
controlneutron=/etc/neutron/neutron.conf
test -f $controlneutron.orig || cp $controlneutron $controlneutron.orig
rm $controlneutron
touch $controlneutron
cat << EOF >> $controlneutron
[DEFAULT]
rpc_backend = neutron.openstack.common.rpc.impl_kombu
rabbit_host = $CON_ADMIN_IP
rabbit_password = $RABBIT_PASS
state_path = /var/lib/neutron
lock_path = \$state_path/lock
core_plugin = neutron.plugins.ml2.plugin.Ml2Plugin
notification_driver = neutron.openstack.common.notifier.rpc_notifier

verbose = True
auth_strategy = keystone
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True
nova_url = http://$CON_ADMIN_IP:8774/v2
nova_admin_username = nova
#Thay ID trong lenh "keystone tenant-get service" vao dong duoi
nova_admin_tenant_id = $SERVICE_ID
nova_admin_password = $NOVA_PASS
nova_admin_auth_url = http://$CON_ADMIN_IP:35357/v2.0
core_plugin = ml2
allow_overlapping_ips = True

# Khai bao cho LB 
service_plugins = router,lbaas

[quotas]

[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf

[keystone_authtoken]
auth_uri = http://$CON_ADMIN_IP:5000
auth_host = $CON_ADMIN_IP
auth_protocol = http
auth_port = 35357
admin_tenant_name = service
admin_user = neutron
admin_password = $NEUTRON_PASS
signing_dir = \$state_path/keystone-signing

[database]
connection = mysql://neutron:$NEUTRON_DBPASS@$CON_ADMIN_IP/neutron

[service_providers]
service_provider=LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
#service_provider=VPN:openswan:neutron.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default

EOF


######## SAO LUU CAU HINH ML2 CHO $CON_ADMIN_IP##################"
echo -e "\e[34m  SUA FILE CAU HINH  ML2 CHO $CON_ADMIN_IP ##########  \e[0m"
sleep 7

controlML2=/etc/neutron/plugins/ml2/ml2_conf.ini
test -f $controlML2.orig || cp $controlML2 $controlML2.orig
rm $controlML2
touch $controlML2

cat << EOF >> $controlML2
[ml2]
type_drivers = gre
tenant_network_types = gre
mechanism_drivers = openvswitch

[ml2_type_flat]

[ml2_type_vlan]

[ml2_type_gre]
tunnel_id_ranges = 1:1000

[ml2_type_vxlan]

[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
enable_security_group = True
EOF



echo -e "\e[34m  ######## KHOI DONG LAI NOVA ########## \e[0m"
sleep 7 
service nova-api restart
service nova-scheduler restart
service nova-conductor restart

echo -e "\e[34m  ########## KHOI DONG LAI NEUTRON ########## \e[0m"
sleep 7 
service neutron-server restart

echo -e "\e[92mThuc thi lenh duoi \e[0m"
echo -e "\e[92mbash control-9.cinder.sh\e[0m"