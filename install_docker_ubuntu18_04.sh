#!/bin/bash

#filename: install_docker_ubuntu18_04.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20190314
#Contact: 836217653@qq.com
#Description: Ubuntu18.04下安装docker
#Usage： sudo sh install_docker_ubuntu18_04.sh
#Website：https://docs.docker.com/install/linux/docker-ce/ubuntu/

update_apt(){
    sudo apt-get update
}

set_apt_use_https(){
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
}

add_key(){
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
}

add_repository(){
     sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) \
    	  stable"
}

#安装docker
install_docker(){
    #安装指定版本 
    #apt-cache madison docker-ce
    #apt-cache madison docker-ce-cli
    #sudo apt-get install docker-ce=5:18.09.1~3-0~ubuntu-xenial  docker-ce-cli=5:18.09.1~3-0~ubuntu-bionic containerd.io

    #安装最新版本
    sudo apt-get install docker-ce docker-ce-cli containerd.io
}

start_docker(){
    sudo systemctl unmask docker.service
    sudo systemctl unmask docker.socket
    sudo systemctl start docker.service
}

main(){
    update_apt
    set_apt_use_https
    add_key
    add_repository
    update_apt
    install_docker
    start_docker
}

main
