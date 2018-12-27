FROM openjdk:8-alpine

ARG hadoop_version=2.8.5
ARG hive_version=3.1.1
ARG hive_storage_version=2.7.0
ARG htrace_version=4.0.1-incubating
ARG spark_version=2.4.0
ARG aws_sdk_version=1.11.467
ARG s3_url=https://s3.us-east-2.amazonaws.com/scos-third-party-repository
ARG tini_version=0.18.0

ENV SPARK_HOME=/opt/spark

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
    mvn_jars=( \
        "hadoop/hadoop-auth/${hadoop_version}/hadoop-auth-${hadoop_version}" \
        "hadoop/hadoop-aws/${hadoop_version}/hadoop-aws-${hadoop_version}" \
        "hadoop/hadoop-common/${hadoop_version}/hadoop-common-${hadoop_version}" \
        "hadoop/hadoop-hdfs/${hadoop_version}/hadoop-hdfs-${hadoop_version}" \
        "hadoop/hadoop-hdfs-client/${hadoop_version}/hadoop-hdfs-client-${hadoop_version}" \
        "hive/hive-beeline/${hive_version}/hive-beeline-${hive_version}" \
        "hive/hive-exec/${hive_version}/hive-exec-${hive_version}" \
        "hive/hive-storage-api/${hive_storage_version}/hive-storage-api-${hive_storage_version}" \
        "htrace/htrace-core4/${htrace_version}/htrace-core4-${htrace_version}" \
    ) && \
    for jar_file in ${mvn_jars[@]}; do \
        wget http://central.maven.org/maven2/org/apache/${jar_file}.jar -P ${SPARK_HOME}/jars; \
    done && \
    ln -s ${SPARK_HOME}/jars/hive-exec-${hive_version}.jar /opt/hive/lib/hive-exec-${hive_version}.jar

COPY log4j.properties ${SPARK_HOME}/conf/log4j.properties

WORKDIR /opt/spark/work-dir

ENTRYPOINT [ "/opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh" ]
