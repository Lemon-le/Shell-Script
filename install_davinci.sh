#!/bin/bash

#FileName: install_davinci.sh
#Date: 20181125
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: 一键安装davinci
#Blog：https://www.cnblogs.com/lemon-le/p/10018676.html


#下载对应的安装包
download(){
    wget http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.13/mysql-connector-java-8.0.13.jar
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz 
    wget https://github.com/edp963/davinci/releases/download/v0.1.0/davinci-assembly_2.11-0.1.0-SNAPSHOT-dist.zip
    wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
}

#指定目标安装目录，判断是否存在，如果不存在则创建，存在就继续
judge_dir(){
    if [ ! -d $target_dir ] ;then
        mkdir $target_dir
    fi
}

#判断系统是否有Java环境，没有就进行Java环境的安装
judge_java(){
    java
    judge=`echo $?`
    if [ $judge -ne 0 ] ;then
        mkdir /usr/java
        tar -zxvf jdk-8u191-linux-x64.tar.gz -C /usr/java 
        echo "JAVA_HOME=/usr/java/jdk1.8.0_191
              CLASSPATH=\$JAVA_HOME/lib/       
              PATH=\$PATH:\$JAVA_HOME/bin     
              export PATH JAVA_HOME CLASSPATH" >> /etc/profile
    fi
    source /etc/profile
}

#判断系统是否有mysql环境，如果没有则安装mysql
judge_mysql(){
    mysql
    judge=`echo $?`
    if [ $judge -ne 0 ] ;then
        yum localinstall mysql57-community-release-el7-8.noarch.rpm 
        yum install mysql-community-server
        systemctl start mysqld
        systemctl enable mysqld
        systemctl daemon-reload
        pass=`grep 'temporary password' /var/log/mysqld.log |awk -F":" '{print $4}' |awk -F" " '{print $1}'`
        mysqladmin -uroot -p$pass password $database_password
        mysql -uroot -p$database_password -e "create database davinci_data"
   fi 
}

#解压安装davinci
install_davinci(){
    unzip davinci-assembly_2.11-0.1.0-SNAPSHOT-dist.zip -d $target_dir/davinci
    cp ./mysql-connector-java-8.0.13.jar $target_dir/davinci/lib
    cd $target_dir/davinci/conf
    mv application.conf.example application.conf
    sed -i 's/from = hutool@yeah.net/from = "hutool@yeah.net"/g' $target_dir/davinci/conf/application.conf
    sed -i 's/user = hutool/user = "hutool"/g' $target_dir/davinci/conf/application.conf
    sed -i 's!jdbc:mysql://localhost:3306/yourdb!jdbc:mysql://localhost:3306/davinci_data!g' $target_dir/davinci/conf/application.conf
    sed -i "s/-proot/-p$database_password/g" $target_dir/davinci/bin/initdb.sh
    sed -i 's/test/davinci_data/g' $target_dir/davinci/bin/initdb.sh
    sed -i 's/password = "*"/password = "$database_password" '  $target_dir/davinci/conf/application.conf
    sed -i 's/userd = "*"/user = "root" '  $target_dir/davinci/conf/application.conf

    echo "export DAVINCI_HOME=$target_dir/davinci" >> /etc/profile
    source /etc/profile
}



main(){
    target_dir=/software
    database_password="Lile@5201314"
    download
    judge_java
    judge_mysql
    install_davinci
    sh $target_dir/davinci/bin/initdb.sh
    sh $target_dir/davinci/bin/start-server.sh
}

main
