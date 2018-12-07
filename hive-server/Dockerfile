FROM java:8u111-jre

ARG hadoop_version=3.1.1
ARG hive_version=3.1.1
ARG spark_version=2.4.0

ENV HADOOP_HOME=/usr/local/hadoop \
    HIVE_HOME=/usr/local/hive

RUN wget http://www.us.apache.org/dist/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
    tar zxf hadoop-${hadoop_version}.tar.gz && \
    mv hadoop-${hadoop_version} /usr/local/hadoop && \
    wget http://www.us.apache.org/dist/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz && \
    tar zxf apache-hive-${hive_version}-bin.tar.gz && \
    mv apache-hive-${hive_version}-bin $HIVE_HOME && \
    rm *.tar.gz

RUN wget http://www.us.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz && \
    tar zxf spark-${spark_version}-bin-hadoop2.7.tgz && \
    mv spark-${spark_version}-bin-hadoop2.7 /usr/local/spark && \
    rm *.tgz

RUN mv /usr/local/spark/jars/spark-network-common*.jar /usr/local/hive/lib/ && \
    mv /usr/local/spark/jars/spark-core*.jar /usr/local/hive/lib/ && \
    mv /usr/local/spark/jars/scala-library*.jar /usr/local/hive/lib/ && \
    mv /usr/local/spark/jars/spark-launcher*.jar /usr/local/hive/lib/

WORKDIR $HIVE_HOME
CMD [ "./bin/hiveserver2" ]
