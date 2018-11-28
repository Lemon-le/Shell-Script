#!/bin/bash

#FileName: iptables_stop.sh
#Date: 20181029
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: Centos7 stop firewalld in grain

install(){
    yum -y install firewalld
    yum -y install iptables-services
}

stop_service(){
    systemctl stop firewalld
    systemctl stop iptables
}

starting_stop(){
    systemctl disable firewalld.service
    systemctl disable iptables.service
}

disabled_selinux(){
     sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
     setenforce 0
}

main(){
    install
    stop_service
    starting_stop
}

main
