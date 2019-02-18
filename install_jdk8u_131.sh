#!/bin/bash

#filename: install_jdk8u_131.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20190218
#Contact: 836217653@qq.com
#Description: 安装jdk1.8.0_131


wget_jdk(){
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
}

install_jdk(){
    tar -zxvf jdk-8u131-linux-x64.tar.gz -C /usr/local
    mv /usr/local/jdk1.8.0_131  /usr/local/java
}

modify_profile(){    
    echo "JAVA_HOME=/usr/local/java
          CLASSPATH=\$JAVA_HOME/lib/       
          PATH=\$PATH:\$JAVA_HOME/bin     
          export PATH JAVA_HOME CLASSPATH" >> /etc/profile
    source /etc/profile
}

main(){
    jdk_install_dir=/usr/local/java
    wget_jdk
    install_jdk
    modify_profile
}

main
