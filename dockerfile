FROM ubuntu:22.04

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y openjdk-8-jdk
RUN apt install -y ssh
RUN apt install -y sudo
RUN addgroup hadoop
RUN adduser --disabled-password --ingroup hadoop hadoop

# enviroment variable #

ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
#hadoop#

COPY hadoop-3.3.6.tar.gz /tmp/
RUN tar -xzf /tmp/hadoop-3.3.6.tar.gz -C /usr/local/


RUN mv /usr/local/hadoop-3.3.6 $HADOOP_HOME
RUN chown -R hadoop:hadoop $HADOOP_HOME
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#ZooKeeper#
ADD https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz /tmp
RUN tar -xzf /tmp/apache-zookeeper-3.8.4-bin.tar.gz -C /usr/local/
RUN mv /usr/local/apache-zookeeper-3.8.4-bin /usr/local/zookeeper
RUN chown -R hadoop:hadoop /usr/local/zookeeper

USER hadoop
WORKDIR /home/hadoop
RUN ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
RUN cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
RUN chmod 600 /home/hadoop//.ssh/authorized_keys

COPY hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY worker $HADOOP_HOME/etc/hadoop/worker
COPY zoo.cfg /usr/local/zookeeper/conf/zoo.cfg
COPY startups.sh /home/hadoop/startups.sh
RUN mkdir -p /usr/local/zookeeper/data

ENTRYPOINT [ "./startups.sh" ]