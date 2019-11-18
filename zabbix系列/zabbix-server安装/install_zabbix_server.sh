#!/bin/bash

#Date: 20191118
#Author: Lile
#Version: V1.0.0
#Description: RPM包的形式啊安装zabbixServer
#Contact: 836217653@qq.com
#Zabbix web: https://www.zabbix.com/download

basic(){
    yum -y install vim lrzsz wget 
}

mysql_rpm(){

    # downlod
    wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm 
    yum localinstall mysql57-community-release-el7-8.noarch.rpm    

    # install
    yum install mysql-community-server
    
    # start
    systemctl start mysqld

    # status
    #systemctl status mysqld
   
    # modify init root password 
    passwd=`grep password /var/log/mysqld.log |awk -F' ' '{print $NF}'`
    mysql -uroot -p$passwd --connect-expired-password -e 'set password for root@localhost=password("Lile@224")'

    # create zabbix account
    mysql -uroot -pLile@224 -e 'create database zabbix'
    mysql -uroot -pLile@224 -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'Zabbix@224';GRANT all privileges ON *.* TO 'zabbix'@'localhost';flush privileges;"
}


zabbix_server(){
    # repo
    rpm -ivh https://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
   
    # yum some basic package
    yum -y install yum-utils
    yum-config-manager --enable rhel-7-server-optional-rpms

    # install server
    yum install zabbix-server-mysql

    echo "DBPassword=Zabbix@224" >> /etc/zabbix/zabbix_server.conf
    # start server 
    systemctl start zabbix-server
    systemctl enable zabbix-server
 
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pZabbix@224 zabbix
}

zabbix_agent(){
    yum install zabbix-agent 
    systemctl start zabbix-agent
}

zabbix_fronend(){
    yum install zabbix-web-mysql 
    systemctl start httpd
}

other(){
    yum install zabbix-get.x86_64
}

main(){
    basic
    mysql_rpm
    zabbix_server
    zabbix_agent
    zabbix_fronend
}

main
