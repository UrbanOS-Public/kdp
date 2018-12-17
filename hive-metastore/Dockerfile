FROM java:8u111-jre

ARG hadoop_version=3.1.1
ARG metastore_version=3.0.0
ARG pg_driver_version=42.2.5
ARG aws_sdk_version=1.11.467

ENV METASTORE_HOME=/usr/local/hive-metastore \
    HADOOP_HOME=/usr/local/hadoop

RUN wget http://www.us.apache.org/dist/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
 tar zxf hadoop-${hadoop_version}.tar.gz && \
 mv hadoop-${hadoop_version} /usr/local/hadoop && \
 wget http://www.us.apache.org/dist/hive/hive-standalone-metastore-${metastore_version}/hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
 tar zxf hive-standalone-metastore-${metastore_version}-bin.tar.gz && \
 mv apache-hive-metastore-${metastore_version}-bin $METASTORE_HOME && \
 rm *.tar.gz

RUN wget https://jdbc.postgresql.org/download/postgresql-${pg_driver_version}.jar --output-document=$METASTORE_HOME/lib/postgres-${pg_driver_version}.jar

RUN wget https://s3.us-east-2.amazonaws.com/scos-third-party-repository/aws-java-sdk/aws-java-sdk-${aws_sdk_version}.jar -P ${METASTORE_HOME}/lib/ && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/${hadoop_version}/hadoop-aws-${hadoop_version}.jar -P ${METASTORE_HOME}/lib/ && \
    wget https://s3.us-east-2.amazonaws.com/scos-third-party-repository/joda-time/joda-time-2.9.9.jar -P ${METASTORE_HOME}/lib/

WORKDIR $METASTORE_HOME
CMD [ "./bin/start-metastore" ]
