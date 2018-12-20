FROM java:8u111-jre

ARG hadoop_version=3.1.1
ARG metastore_version=3.0.0
ARG pg_driver_version=42.2.5
ARG s3_url=https://s3.us-east-2.amazonaws.com/scos-third-party-repository

ENV METASTORE_HOME=/usr/local/hive-metastore \
    HADOOP_HOME=/usr/local/hadoop

RUN wget ${s3_url}/hadoop/hadoop-${hadoop_version}.tar.gz && \
    tar zxf hadoop-${hadoop_version}.tar.gz && \
    mv hadoop-${hadoop_version} ${HADOOP_HOME} && \
    wget ${s3_url}/hive-standalone-metastore/hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
    tar zxf hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
    mv apache-hive-metastore-${metastore_version}-bin $METASTORE_HOME && \
    mv ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${hadoop_version}.jar ${METASTORE_HOME}/lib/ && \
    mv ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-*.jar ${METASTORE_HOME}/lib/ && \
    rm -r ${HADOOP_HOME}/share/hadoop/mapreduce/* ${HADOOP_HOME}/share/hadoop/tools/* ${HADOOP_HOME}/share/hadoop/yarn/* ${HADOOP_HOME}/share/doc && \
    rm *.tar.gz

RUN wget ${s3_url}/postgresql/postgresql-${pg_driver_version}.jar -P $METASTORE_HOME/lib/ && \
    wget ${s3_url}/joda-time/joda-time-2.9.9.jar -P ${METASTORE_HOME}/lib/

WORKDIR $METASTORE_HOME
