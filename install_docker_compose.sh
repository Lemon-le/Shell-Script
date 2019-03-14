#!/bin/bash

#filename: install_docker.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20190314
#Contact: 836217653@qq.com
#Description: Centos7下安装docker-compose
#Usage： sudo sh install_docker_compose.sh

install(){
    curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version
}

main(){
    install
}

main
