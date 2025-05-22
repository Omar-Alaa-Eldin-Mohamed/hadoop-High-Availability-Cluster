#!/bin/bash

sudo service ssh start


if hostname | grep -q 'master'
then
	export PATH=$PATH:/usr/local/zookeeper/bin

	
    ID=$(hostname | tail -c 2) 
    echo $ID > /usr/local/zookeeper/data/myid
    if [ $ID -eq 1 ]
    then
		hdfs zkfc -formatZK -force
    fi
	hdfs --daemon start journalnode
	zkServer.sh start
	
    if [ $ID -eq 1 ]
	then
        hdfs namenode -format
    else
        hdfs namenode -bootstrapStandby
    fi