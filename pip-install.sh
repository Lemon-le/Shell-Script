#!/bin/bash

#FileName: pip-install.sh
#Date: 20181015
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: Source Package Install pip


install(){
    wget https://files.pythonhosted.org/packages/45/ae/8a0ad77defb7cc903f09e551d88b443304a9bd6e6f124e75c0fbbf6de8f7/pip-18.1.tar.gz
    tar -zxvf pip-18.1.tar.gz 
    cd pip-18.1
    python setup.py install
    pip -v
	}
	
main(){
    install
}

main