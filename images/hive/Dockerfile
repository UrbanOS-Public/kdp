FROM openjdk:8-alpine

ARG hadoop_version=2.8.5
ARG hive_version=3.1.1
ARG spark_version=2.4.0

ENV HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/hive \
    SPARK_HOME=/opt/spark

RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat && \
    rm /bin/sh && \
    mkdir /opt && \
    ln -sv /bin/bash /bin/sh

SHELL ["/bin/bash", "-c"]
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
    tar zxf hadoop-${hadoop_version}.tar.gz && \
    mv hadoop-${hadoop_version} ${HADOOP_HOME} && \
    wget https://archive.apache.org/dist/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz && \
    tar zxf apache-hive-${hive_version}-bin.tar.gz && \
    mv apache-hive-${hive_version}-bin ${HIVE_HOME} && \
    wget https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz && \
    tar zxf spark-${spark_version}-bin-hadoop2.7.tgz && \
    mv spark-${spark_version}-bin-hadoop2.7 ${SPARK_HOME} && \
    mv ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${hadoop_version}.jar ${HIVE_HOME}/lib/ && \
    rm *.tar.gz && \
    rm -r ${HADOOP_HOME}/share/hadoop/tools/* && \
    rm -r ${HADOOP_HOME}/share/hadoop/yarn/* && \
    rm -r ${HADOOP_HOME}/share/doc

RUN wget https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip -P /tmp/ && \
    unzip "/tmp/aws-java-sdk.zip" -d "/tmp" && \
    rm /tmp/aws-java-sdk-*/lib/aws-java-sdk-*-{javadoc,sources}.jar && \
    mv /tmp/aws-java-sdk-*/lib/aws-java-sdk-*.jar ${SPARK_HOME}/jars/aws-java-sdk.jar && \
    ln -s ${SPARK_HOME}/jars/aws-java-sdk.jar ${HIVE_HOME}/lib/aws-java-sdk.jar && \
    rm -r /tmp/aws-java-sdk* && \
    rm ${SPARK_HOME}/jars/{htrace-core-*,hadoop-annotations-*,hadoop-auth-*,hadoop-common-*,hadoop-hdfs-*,hive-*.spark2}.jar

RUN ln -s ${SPARK_HOME}/jars/spark-network-common_2.11-${spark_version}.jar ${HIVE_HOME}/lib/spark-network-common_2.11-${spark_version}.jar && \
    ln -s ${SPARK_HOME}/jars/scala-library-2.11.12.jar ${HIVE_HOME}/lib/scala-library-2.11.12.jar && \
    ln -s ${SPARK_HOME}/jars/spark-core_2.11-${spark_version}.jar ${HIVE_HOME}/lib/spark-core_2.11-${spark_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-beeline-${hive_version}.jar ${SPARK_HOME}/jars/hive-beeline-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-storage-api-2.7.0.jar ${SPARK_HOME}/jars/hive-storage-api-2.7.0.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/lib/hadoop-auth-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-auth-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/hadoop-common-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-common-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/hdfs/hadoop-hdfs-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-hdfs-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/hdfs/hadoop-hdfs-client-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-hdfs-client-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/hdfs/lib/htrace-core4-4.0.1-incubating.jar ${SPARK_HOME}/jars/htrace-core4-4.0.1-incubating.jar

COPY log4j.properties ${SPARK_HOME}/conf/log4j.properties
