#!/bin/bash

#filename: install_mongo.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20191025
#Contact: 836217653@qq.com
#Description: install mongo-4.2 https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/
#Usage： sudo sh install_mongo_4.2.sh

cat <<EOF > /etc/yum.repos.d/mongodb.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

yum install -y mongodb-org
