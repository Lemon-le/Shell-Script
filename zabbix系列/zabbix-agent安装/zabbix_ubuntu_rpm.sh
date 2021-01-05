#!/bin/bash

#Date: 20190428
#Author: Lile
#Version: V1.0.0
#Description：ubuntu下安装zabbix
#Contact: 836217653@qq.com
#Zabbix web: https://www.zabbix.com/download

install(){

    wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb 
    dpkg -i zabbix-release_3.2-1+xenial_all.deb
    apt-get update
    apt-get install libcurl3 -y
    apt-get install -y zabbix-agent

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
