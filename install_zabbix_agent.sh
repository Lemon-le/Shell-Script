#!/bin/bash

#Date: 20180408
#Author: Lile
#Description: install zabbix agent
#Contact: 15274326058


install_zabbix(){

wget --no-check-certificate https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.4.7/zabbix-3.4.7.tar.gz
  
yum -y install pcre*

tar -zxvf zabbix-3.4.7.tar.gz

cd zabbix-3.4.7

./configure --prefix=/usr/local/zabbix-3.4.7 --enable-agent
make 
make install

}

modify_file(){

sed -i "s/^Server=127.0.0.1/Server=$1/g" /usr/local/zabbix-3.4.7/etc/zabbix_agentd.conf 
sed -i "s/^ServerActive=127.0.0.1/ServerActive=$1/g" /usr/local/zabbix-3.4.7/etc/zabbix_agentd.conf 

}

is_true_zabbix(){

cat /etc/passwd |grep zabbix
is_true=`echo $?`

if [ $is_true -ne 0 ];then
    useradd zabbix
fi

}

add_service_start(){

cp /root/zabbix-3.4.7/misc/init.d/fedora/core/zabbix_agentd  /etc/init.d/zabbix_agentd

sed -i 's!BASEDIR=/usr/local!BASEDIR=/usr/local/zabbix-3.4.7!g' /etc/init.d/zabbix_agentd

}


start_zabbix(){

service zabbix_agentd start

}

main(){

zabbix_server="192.168.43.203"

install_zabbix
modify_file $zabbix_server
is_true_zabbix
add_service_start
start_zabbix

}

main
