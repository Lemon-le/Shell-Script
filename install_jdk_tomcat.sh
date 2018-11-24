#!/bin/bash

#filename: install_jdk_tomcat.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20181124
#Contact: 836217653@qq.com
#Description: Install JDK and Tomcat 

#install some basic tool
tools_install(){
    sudo yum -y install vim
}

iptables_stop(){
    sudo yum -y install firewalld
    sudo yum -y install iptables-services
    sudo systemctl stop firewalld
    sudo systemctl stop iptables
    sudo systemctl disable firewalld.service
    sudo systemctl disable iptables.service
}

selinux_disabled(){
    sudo setenforce 0
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
}


install_jdk_tomcat(){
     install_type=$1
     install_dir=$2
     filename=$3

     install_name=`echo ${install_dir%/*} `
     dir_name=`echo ${install_dir##*/} `
     
     if [ ! -d $install_name ] ;then
        sudo mkdir -p $install_name
     fi

     sudo tar -zxvf $filename -C $install_name
     tar_dirname=`ls $install_name |grep "$install_type"`
     sudo mv $install_name/$tar_dirname $install_name/$dir_name

}

install_jdk(){
    install_jdk_tomcat jdk $jdk_install_dir $jdk_filename
    echo "JAVA_HOME=$jdk_install_dir
          CLASSPATH=\$JAVA_HOME/lib/       
          PATH=\$PATH:\$JAVA_HOME/bin     
          export PATH JAVA_HOME CLASSPATH" >> /etc/profile
    source /etc/profile
}


install_apache(){
    install_jdk_tomcat tomcat $tomcat_install_dir $tomcat_filename
    sed -i "2i\\export JAVA_HOME=$jdk_install_dir" $tomcat_install_dir/bin/startup.sh
    

}

main(){
    jdk_install_dir=/usr/install/java
    jdk_filename=jdk-8u151-linux-x64.tar.gz
    tomcat_install_dir=/usr/install/tomcat7
    tomcat_filename=apache-tomcat-7.0.92.tar.gz
    iptables_stop
    selinux_disabled
    install_jdk
    install_apache
}


main
