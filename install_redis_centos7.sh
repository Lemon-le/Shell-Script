#!/bin/bash

#FileName: install_redis_centos7.sh
#Date: 20190523
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: centos7下安装redis


install_env(){
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
    yum repolist 
}


download(){
    wget http://download.redis.io/releases/redis-5.0.5.tar.gz
    tar xzf redis-5.0.5.tar.gz
    cd redis-5.0.5
    make
}

install_env
download
