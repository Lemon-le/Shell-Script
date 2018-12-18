#!/bin/bash

#Date: 20180408
#Author: Lile
#Version: V1.0.0
#Description: 源码包的形式啊安装zabbix agent
#Contact: 836217653@qq.com


install_zabbix(){

yum -y install pcre* gcc wget

if [ ! -d $software_dir ];then
    mkdir $software_dir
fi

cd $software_dir

wget --no-check-certificate https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.4.7/zabbix-3.4.7.tar.gz

tar -zxvf zabbix-3.4.7.tar.gz

cd zabbix-3.4.7

./configure --prefix="$install_dir" --enable-agent
make 
make install

}

modify_file(){

sed -i "s/^Server=127.0.0.1/Server=$1/g" $install_dir/etc/zabbix_agentd.conf 
sed -i "s/^ServerActive=127.0.0.1/ServerActive=$1/g" $install_dir/etc/zabbix_agentd.conf 

}

is_true_zabbix(){

cat /etc/passwd |grep zabbix
is_true=`echo $?`

if [ $is_true -ne 0 ];then
    useradd zabbix
fi

}

add_service_start(){

cp $software_dir/zabbix-3.4.7/misc/init.d/fedora/core/zabbix_agentd  /etc/init.d/zabbix_agentd

sed -i "s!BASEDIR=/usr/local!BASEDIR=$install_dir!g" /etc/init.d/zabbix_agentd

}


start_zabbix(){

service zabbix_agentd start

}

main(){

#指定zabbix server端地址
zabbix_server="192.168.43.203"

#指定软件下载路径
software_dir=/software

#指定软件安装路径
install_dir=/usr/local/zabbix

install_zabbix
modify_file $zabbix_server
is_true_zabbix
add_service_start
start_zabbix

}

main
