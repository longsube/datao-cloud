#!/bin/bash 
#


cat << EOF > config.cfg
## Khai bao IP cho CONTROLLER NODE
CON_ADMIN_IP=10.145.37.231
CON_EXT_IP=10.20.0.11

# Khai bao IP cho NETWORK NODE
NET_ADMIN_IP=10.145.37.232
NET_EXT_IP=172.16.69.221
NET_DATA_VM_IP=10.40.0.21

# Khai bao IP cho COMPUTE1 NODE
COM1_ADMIN_IP=10.145.37.233
COM1_DATA_VM_IP=10.40.0.31

# Khai bao IP cho COMPUTE2 NODE
COM2_ADMIN_IP=10.145.37.234
COM2_DATA_VM_IP=10.40.0.32

# Khai bao IP cho COMPUTE3 NODE
COM3_ADMIN_IP=10.145.37.235
COM3_DATA_VM_IP=10.40.0.33

GATEWAY_IP=10.145.37.5
GATEWAY_NET=172.16.69.1

NETMASK_ADD=255.255.255.0
NETMASK_ADD_VM=255.255.0.0
NETMASK_ADD_PUB=255.255.255.0


# Set password
DEFAULT_PASS='Welcome123'

RABBIT_PASS=`openssl rand -hex 10`
MYSQL_PASS=`openssl rand -hex 10`
TOKEN_PASS=`openssl rand -hex 10`
ADMIN_PASS=`openssl rand -hex 10`
DEMO_PASS=`openssl rand -hex 10`
SERVICE_PASSWORD=`openssl rand -hex 10`
METADATA_SECRET=`openssl rand -hex 10`

# PASS CHO DB
KEYSTONE_DBPASS=`openssl rand -hex 10`
NOVA_DBPASS=`openssl rand -hex 10`
CINDER_DBPASS=`openssl rand -hex 10`
GLANCE_DBPASS=`openssl rand -hex 10`
NEUTRON_DBPASS=`openssl rand -hex 10`

# PASS cho service
KEYSTONE_PASS=`openssl rand -hex 10`
NOVA_PASS=`openssl rand -hex 10`
CINDER_PASS=`openssl rand -hex 10`
GLANCE_PASS=`openssl rand -hex 10`
NEUTRON_PASS=`openssl rand -hex 10`


SERVICE_TENANT_NAME="service"
ADMIN_TENANT_NAME="admin"
DEMO_TENANT_NAME="demo"
INVIS_TENANT_NAME="invisible_to_admin"
ADMIN_USER_NAME="admin"
DEMO_USER_NAME="demo"


REGIONNAME=HANOI
ADMIN_ROLE_NAME="admin"
MEMBER_ROLE_NAME="Member"
KEYSTONEADMIN_ROLE_NAME="KeystoneAdmin"
KEYSTONESERVICE_ROLE_NAME="KeystoneServiceAdmin"



# OS_SERVICE_TOKEN="$DEFAULT_PASS"
EOF