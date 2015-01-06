#!/bin/bash -ex
#
source config.cfg

echo -e "\e[34m ##### Cai dat keystone #####\e[0m"
apt-get install keystone -y

#/* Sao luu truoc khi sua file nova.conf
filekeystone=/etc/keystone/keystone.conf
test -f $filekeystone.orig || cp $filekeystone $filekeystone.orig

#Chen noi dung file /etc/keystone/keystone.conf
cat << EOF > $filekeystone
[DEFAULT]
admin_token = $TOKEN_PASS
log_dir = /var/log/keystone
[assignment]
[auth]
[cache]
[catalog]
[credential]
[database]
connection = mysql://keystone:$KEYSTONE_DBPASS@$CON_ADMIN_IP/keystone
[ec2]
[endpoint_filter]
[federation]
[identity]
[kvs]
[ldap]
[matchmaker_ring]
[memcache]
[oauth1]
[os_inherit]
[paste_deploy]
[policy]
[revoke]
[signing]
[ssl]
[stats]
[token]
[trust]
[extra_headers]
Distribution = Ubuntu
EOF
#
echo -e "\e[34m ##### Xoa DB mac dinh #####\e[0m"
rm  /var/lib/keystone/keystone.db

echo -e "\e[34m ##### Khoi dong lai MYSQL #####\e[0m"
service keystone restart
sleep 3
service keystone restart

echo -e "\e[34m ##### Dong bo cac bang trong DB #####\e[0m"
sleep 3
keystone-manage db_sync

(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' >> /var/spool/cron/crontabs/keystone

echo -e "\e[92m Thu thi lenh duoi \e[0m"
echo -e "\e[92m bash control-5-creatusetenant.sh \e[0m"

