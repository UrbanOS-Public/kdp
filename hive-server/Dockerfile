FROM java:8u111-jre

ARG hadoop_version=3.1.1
ARG hive_version=3.1.1

ENV HADOOP_HOME=/usr/local/hadoop \
    HIVE_HOME=/usr/local/hive

RUN wget http://apache.claz.org/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
 tar zxf hadoop-${hadoop_version}.tar.gz && \
 mv hadoop-${hadoop_version} /usr/local/hadoop && \
 wget http://apache.claz.org/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz && \
 tar zxf apache-hive-${hive_version}-bin.tar.gz && \
 mv apache-hive-${hive_version}-bin $HIVE_HOME && \
 rm *.tar.gz

WORKDIR $HIVE_HOME
CMD [ "./bin/hiveserver2" ]
