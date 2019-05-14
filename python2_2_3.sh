#!/bin/bash

#FileName: python2_2_3.sh
#Date: 20190514
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: Centos7下python2升级成Python3

download(){
    wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
    xz -d Python-3.7.3.tar.xz
    tar -xvf Python-3.7.3.tar
}

compile(){
    yum install -y libffi libffi-devel
    cd Python-3.7.3
    ./configure --prefix=/usr/local/python3 --with-ssl --enable-shared
    make && make install
}

create_link(){
    ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3
	ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
    echo "/usr/local/python3/lib" >/etc/ld.so.conf.d/python3.conf
    ldconfig
    python3 --version
}

main(){
    download
    compile
    create_link
}

main
