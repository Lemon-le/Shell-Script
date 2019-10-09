#!/bin/bash

#FileName: clean_log.sh
#Date: 20190920
#Author: LiLe
#Contact: 836217653@qq.com
#Version: V1.0
#Description: 定时清理指定目录下的10天以前的日志

# 指定需要清理的目录

dirs=(/data/tomcat1/logs \
      /data/tomcat2/logs \
      /data/kafka_2.11-2.0.0/logs )

# 指定清理的时间
period=10

for dir in ${dirs[*]}
do
    find $dir -type d -mtime +$period ! -name "logs" |xargs rm -rf
    find $dir -type f -mtime +$period ! -name "logs" |xargs rm -rf
done

