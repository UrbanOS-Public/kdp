FROM java:8u111-jre

ENV HADOOP_HOME=/usr/local/hadoop \
    HIVE_HOME=/usr/local/hive

RUN apt update && apt install -y vim
RUN wget http://apache.claz.org/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz && \
 tar zxf hadoop-3.1.1.tar.gz && \
 mv hadoop-3.1.1 /usr/local/hadoop && \
 wget http://apache.claz.org/hive/hive-3.1.1/apache-hive-3.1.1-bin.tar.gz && \
 tar zxf apache-hive-3.1.1-bin.tar.gz && \
 mv apache-hive-3.1.1-bin $HIVE_HOME && \
 rm *.tar.gz

COPY hive-site.xml $HIVE_HOME/conf/hive-site.xml


WORKDIR $HIVE_HOME
CMD [ "./bin/hiveserver2" ]
