#!/bin/bash

#Date: 20190428
#Author: Lile
#Version: V1.0.0
#Description: 安装gradle
#Contact: 836217653@qq.com


install_jdk(){
   #下载
   wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

   #解压
   tar -zxvf jdk-8u131-linux-x64.tar.gz -C /usr/local
   mv /usr/local/jdk1.8.0_131  /usr/local/java

   #修改配置文件
   echo "JAVA_HOME=/usr/local/java
         CLASSPATH=\$JAVA_HOME/lib/       
         PATH=\$PATH:\$JAVA_HOME/bin     
         export PATH JAVA_HOME CLASSPATH" >> /etc/profile
   source /etc/profile

}


install_gradle(){
    wget https://downloads.gradle.org/distributions/gradle-4.6-bin.zip
    unzip -d $gradle_install_dir gradle-4.6-bin.zip


    echo "PATH=\$PATH:$gradle_install_dir/gradle-4.6/bin
    export PATH" >>/etc/profile
    
    source /etc/profile
}



main(){
    jdk_install_dir=/usr/local/java
    gradle_install_dir=/usr/local/
    
    java -version
    code=`echo $?`
    echo $code
    
    if [ $code -ne 0 ];then
        install_jdk
    fi

    install_gradle
   
}

main

