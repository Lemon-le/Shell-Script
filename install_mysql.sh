#!/bin/bash

#filename: install_mysql.sh
#Version: v1.0.0
#Author: LiLe
#Date: 20181124
#Contact: 836217653@qq.com
#Description: Install Mysql

down(){
    wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.23-linux-glibc2.12-x86_64.tar.gz
}

install_mysql(){
     sudo yum -y install libaio*
    install_dir=`echo ${mysql_install_dir%/*}`
    dir_name=`echo ${mysql_install_dir##*/} `
    if [ ! -d $install_dir ] ;then
        sudo mkdir -p $install_dir
    fi
    tar -zxvf $mysql_filename -C $install_dir
    static=`echo $mysql_filename |awk -F"-" '{print $2}'`
    tar_filename=`ls $install_dir|grep $static`
    sudo mv $install_dir/$tar_filename $install_dir/$dir_name
}


init_mysql(){
    sudo useradd mysql
    if [ ! -d $mysql_data ] ;then
        sudo mkdir -p $mysql_data
    fi
    sudo chown -R mysql.mysql $mysql_data
    sudo chmod -R 777 $mysql_data
    sudo $mysql_install_dir/bin/mysqld --initialize --user=mysql --basedir=$mysql_install_dir --datadir=$mysql_data
}

config_mysql(){
    if [ -f $config_file ] ;then
        sudo cp $config_file $config_file\.bak
        sudo rm $config_file
    fi

    sudo cp $mysql_install_dir/support-files/mysql.server /etc/init.d/mysql
    sed -i "s!^basedir=!basedir=$mysql_install_dir!g" /etc/init.d/mysql
    sed -i "s!^datadir=!datadir=$mysql_data!g" /etc/init.d/mysql
    chmod +x /etc/init.d/mysql

    echo "export PATH=\$PATH:$mysql_install_dir:$mysql_install_dir/bin" >> /etc/profile
    source /etc/profile
    
    cat <<EOF > $config_file
[mysqld]
datadir = ${mysql_data} 
port = 3306
server_id = 1
socket = ${mysql_data}/mysql.sock
log-error = ${mysql_data}/mysql.error
pid-file = ${mysql_data}/mysql.pid
character_set_server = utf8
collation-server = utf8_general_ci
lower_case_table_names = 1
max_allowed_packet = 100M
max_connections = 1000
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES 
log-bin=master-bin


[client]
default-character-set=utf8
socket = ${mysql_data}/mysql.sock

[mysql]
default-character-set=utf8
EOF
}

start_mysql(){
   sudo chmod 777 $mysql_data/ibdata1
   sudo rm  $mysql_data/ib_logfile0
   sudo rm  $mysql_data/ib_logfile1
   sudo systemctl daemon-reload
   sudo systemctl start mysql

}

main(){
    mysql_install_dir=/usr/local/mysql
    mysql_filename=mysql-5.7.23-linux-glibc2.12-x86_64.tar.gz
    mysql_data=/data/mysql
    config_file=/etc/my.cnf
    down
    install_mysql
    init_mysql
    config_mysql
    start_mysql
}


main

