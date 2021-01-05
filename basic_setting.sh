#!/bin/bash

#FileName: basic_setting.sh
#Date: 20191114
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: Centos7 setting openfiles and max prossor


# 安装相关常用的工具命令
basic_tools(){
    yum -y install lrzsz vim wget dos2unix lsof telnet
}

# 最大文件打开数
open_file(){
    echo "*       soft    nofile 65536 " >> /etc/security/limits.conf
    echo "*       hard    nofile 65536 " >> /etc/security/limits.conf
    echo "*       soft    nproc  65536 "  >> /etc/security/limits.conf
    echo "*       hard    nproc  65536 "  >> /etc/security/limits.conf
}

main(){
    basic_tools
    open_file
}

main
