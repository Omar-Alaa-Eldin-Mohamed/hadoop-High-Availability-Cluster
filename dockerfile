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
