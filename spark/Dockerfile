FROM openjdk:8-alpine

ARG hadoop_version=2.8.5
ARG hive_version=3.1.1
ARG spark_version=2.4.0
ARG aws_sdk_version=1.11.467
ARG s3_url=https://s3.us-east-2.amazonaws.com/scos-third-party-repository
ARG tini_version=0.18.0

ENV SPARK_HOME=/opt/spark \
    LOG_LEVEL=INFO

RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat linux-pam && \
    mkdir -p /opt/hive/lib && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

SHELL ["/bin/bash", "-c"]
RUN wget https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz && \
    tar zxf spark-${spark_version}-bin-hadoop2.7.tgz && \
    mv spark-${spark_version}-bin-hadoop2.7 ${SPARK_HOME} && \
    rm -r *.tgz && \
    rm ${SPARK_HOME}/jars/{htrace-core*,hadoop-hdfs-*,hadoop-common-*,hadoop-auth-*,hadoop-annotations-*,hive-*.spark2}.jar

RUN wget ${s3_url}/aws-java-sdk/aws-java-sdk-${aws_sdk_version}.jar -P ${SPARK_HOME}/jars/ && \
    wget http://central.maven.org/maven2/org/apache/htrace/htrace-core4/4.0.1-incubating/htrace-core4-4.0.1-incubating.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hive/hive-storage-api/2.7.0/hive-storage-api-2.7.0.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hive/hive-beeline/${hive_version}/hive-beeline-${hive_version}.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-hdfs-client/${hadoop_version}/hadoop-hdfs-client-${hadoop_version}.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-hdfs/${hadoop_version}/hadoop-hdfs-${hadoop_version}.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-common/${hadoop_version}/hadoop-common-${hadoop_version}.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-auth/${hadoop_version}/hadoop-auth-${hadoop_version}.jar -P ${SPARK_HOME}/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/${hadoop_version}/hadoop-aws-${hadoop_version}.jar -P ${SPARK_HOME}/jars

RUN wget http://central.maven.org/maven2/org/apache/hive/hive-exec/${hive_version}/hive-exec-${hive_version}.jar -P /opt/hive/lib

# RUN wget https://github.com/krallin/tini/releases/download/v${tini_version}/tini-amd64 -O /sbin/tini && \
#     chmod +x /sbin/tini 

COPY log4j.properties ${SPARK_HOME}/conf/log4j.properties

WORKDIR /opt/spark/work-dir

ENTRYPOINT [ "/opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh" ]
