#!/bin/bash

#FileName: yum_replace.shy
#Date: 20190111
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: Centos7下替换成163yum源
#Blog：https://www.cnblogs.com/lemon-le/p/9151988.html


main(){

    cd /etc/yum.repos.d

    mv CentOS-Base.repo CentOS-Base.repo.old

    wget http://mirrors.aliyun.com/repo/Centos-7.repo

    mv Centos-7.repo CentOS-Base.repo

    yum clean all

    yum makecache

}

main
