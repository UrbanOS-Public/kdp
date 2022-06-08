FROM openjdk:8-alpine

ARG hadoop_version=3.1.1
ARG joda_version=2.9.9
ARG metastore_version=3.0.0
ARG pg_driver_version=42.2.5
ARG apache_url=http://archive.apache.org/dist
ARG mvn_url=https://repo1.maven.org/maven2

ARG jmx_exporter_version="0.11.0"
ARG jmx_exporter_bin="https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${jmx_exporter_version}/jmx_prometheus_javaagent-${jmx_exporter_version}.jar"


ENV METASTORE_HOME=/opt/hive-metastore \
    HADOOP_HOME=/opt/hadoop
RUN set -ex && \
    apk add --no-cache bash tini libc6-compat linux-pam curl ca-certificates && \
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

RUN wget -q $jmx_exporter_bin -O jmx_exporter.jar

RUN curl -L \
    -o /usr/local/share/ca-certificates/rds-ca-2019-root.crt \
    https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem \
    && update-ca-certificates \
    && rm /etc/ssl/cert.pem \
    && ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem

RUN chgrp -R 0 ${METASTORE_HOME} && \
    chmod -R g+rwX ${METASTORE_HOME}

RUN chgrp -R 0 ${HADOOP_HOME} && \
    chmod -R g+rwX ${HADOOP_HOME}

RUN chgrp -R 0 /etc/ssl/certs && \
    chmod -R g+rwX /etc/ssl/certs