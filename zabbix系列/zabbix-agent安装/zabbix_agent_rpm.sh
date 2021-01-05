#!/bin/bash

#Date: 20181214
#Author: Lile
#Version: V1.0.0
#Description: RPM包的形式啊安装zabbix agent
#Contact: 836217653@qq.com
#Zabbix web: https://www.zabbix.com/download

install(){

rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum -y install zabbix-agent

}

modify_file(){

sed -i "s/^Server=127.0.0.1/Server=$1/g" /etc/zabbix/zabbix_agentd.conf 
sed -i "s/^ServerActive=127.0.0.1/ServerActive=$1/g" /etc/zabbix/zabbix_agentd.conf 

}

start_zabbix(){

systemctl start zabbix-agent
systemctl enable zabbix-agent

}

server_address=172.29.43.7

main(){

install
modify_file $server_address
start_zabbix

}

main

