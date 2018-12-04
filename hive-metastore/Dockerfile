FROM java:8u111-jre

ARG hadoop_version=3.1.1
ARG metastore_version=3.0.0
ARG pg_driver_version=42.2.5

ENV METASTORE_HOME=/usr/local/hive-metastore \
    HADOOP_HOME=/usr/local/hadoop

RUN wget http://apache.claz.org/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
 tar zxf hadoop-${hadoop_version}.tar.gz && \
 mv hadoop-${hadoop_version} /usr/local/hadoop && \
 wget http://apache.claz.org/hive/hive-standalone-metastore-${metastore_version}/hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
 tar zxf hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
 mv apache-hive-metastore-${metastore_version}-bin $METASTORE_HOME && \
 rm *.tar.gz

RUN wget https://jdbc.postgresql.org/download/postgresql-${pg_driver_version}.jar --output-document=$METASTORE_HOME/lib/postgres-${pg_driver_version}.jar

WORKDIR $METASTORE_HOME
CMD [ "./bin/start-metastore" ]
