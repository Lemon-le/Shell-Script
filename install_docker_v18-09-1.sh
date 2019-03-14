#!/bin/bash

#filename: install_docker_v18-09-1.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20190314
#Contact: 836217653@qq.com
#Description: Centos7下安装docker 18.09.1版本
#Usage： sudo sh install_docker.sh

#卸载原有版本
yum remove docker \
           docker-common \
           docker-selinux \
           docker-engine

#设置Docker的镜像仓库并从中进行安装（推荐使用从镜像仓库安装）

#安装所需的依赖包
yum install -y yum-utils \
               device-mapper-persistent-data \
               lvm2

#设置stable镜像仓库
yum-config-manager \
     --add-repo \
     https://download.docker.com/linux/centos/docker-ce.repo

#更新软件包索引
yum makecache fast

#安装Docker CE（这是安装最新版本）；如果是生产环境应该固定统一使用一个版本，而不是每次都是安装最新版本

#可以选择想要安装的版本,这里安装最新的
#yum list docker-ce  --showduplicates | sort -r  
yum install docker-ce-18.09.1  docker-ce-cli-18.09.1
#yum install docker-ce

#启动
systemctl start docker


