FROM openjdk:8-alpine

ARG hadoop_version=3.1.1
ARG joda_version=2.9.9
ARG metastore_version=3.0.0
ARG pg_driver_version=42.2.5
ARG apache_url=http://archive.apache.org/dist
ARG mvn_url=http://central.maven.org/maven2

ENV METASTORE_HOME=/opt/hive-metastore \
    HADOOP_HOME=/opt/hadoop

RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat linux-pam && \
    mkdir -p /opt && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh

SHELL ["/bin/bash", "-c"]

RUN wget ${apache_url}/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
    tar zxf hadoop-${hadoop_version}.tar.gz && \
    mv hadoop-${hadoop_version} ${HADOOP_HOME} && \
    wget ${apache_url}/hive/hive-standalone-metastore-${metastore_version}/hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
    tar zxf hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
    mv apache-hive-metastore-${metastore_version}-bin $METASTORE_HOME && \
    mv ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${hadoop_version}.jar ${METASTORE_HOME}/lib/ && \
    mv ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-*.jar ${METASTORE_HOME}/lib/ && \
    rm -r ${HADOOP_HOME}/share/hadoop/{mapreduce/*,tools/*,yarn/*} ${HADOOP_HOME}/share/doc && \
    rm *.tar.gz

RUN wget ${mvn_url}/org/postgresql/postgresql/${pg_driver_version}/postgresql-${pg_driver_version}.jar -P $METASTORE_HOME/lib/ && \
    wget ${mvn_url}/joda-time/joda-time/${joda_version}/joda-time-${joda_version}.jar -P ${METASTORE_HOME}/lib/

WORKDIR $METASTORE_HOME
