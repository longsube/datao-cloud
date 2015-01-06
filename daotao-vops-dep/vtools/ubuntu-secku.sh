#!/bin/bash
# Thiet lap cho ubuntu 

echo "#### Sao luu file cau hinh #####"
filessh=/etc/ssh/sshd_config
test -f $filessh.bka || cp $filessh $filessh.bka
echo "##### Cau hinh cho ssh #####"
read -p"Nhap port can thay doi:" portssh
sed -i "s/Port 22/Port $portssh/g" $filessh
sed -i "s/PermitRootLogin yes/PermitRootLogin without-password/g" /etc/ssh/sshd_config

echo "##### Cai dat TCPD #####"
sudo apt-get install tcpd
echo "##### Sao luu cac file cua TCPD #####"
filehostdeny=/etc/hosts.deny
filehostallow=/etc/hosts.allow
test -f $filehostdeny.bka || cp $filehostdeny $filehostdeny.bka
test -f $filehostallow.bka || cp $filehostallow $filehostallow.bka

sleep 5
echo "###### Cau hinh TCPD ######"
echo -e "\e[92m ##### Nhap IP duoi vao ##### \e[0m" 
echo -e "\e[92m ##### 203.162.130.231 ##### \e[0m" 
read -p"Nhap host duoc phep SSH: " allowssh
echo "sshd: $allowssh 10.30.0. 203.162.130.241 118.70.182.1" >> $filehostallow

echo "sshd: ALL" >> $filehostdeny

echo "Khoi dong lai may"
sleep 3
init 6
