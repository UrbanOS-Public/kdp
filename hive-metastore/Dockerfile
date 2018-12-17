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

RUN ln -s ${HADOOP_HOME}/share/hadoop/common/lib/hadoop-annotations-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-annotations-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/lib/hadoop-auth-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-auth-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/client/hadoop-client-api-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-client-api-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/client/hadoop-client-minicluster-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-client-minicluster-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/client/hadoop-client-runtime-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-client-runtime-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/hadoop-common-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-common-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/hadoop-common-${hadoop_version}-sources.jar ${METASTORE_HOME}/lib/hadoop-common-${hadoop_version}-sources.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/hdfs/hadoop-hdfs-${hadoop_version}.jar ${METASTORE_HOME}/lib/hadoop-hdfs-${hadoop_version}.jar && \
    rm /usr/local/hadoop/share/hadoop/common/lib/guava-*.jar /usr/local/hadoop/share/hadoop/hdfs/lib/guava-*.jar && \
    ln -s ${METASTORE_HOME}/lib/guava-19.0.jar ${HADOOP_HOME}/share/hadoop/common/lib/guava-19.0.jar && \
    ln -s ${METASTORE_HOME}/lib/guava-19.0.jar ${HADOOP_HOME}/share/hadoop/hdfs/lib/guava-19.0.jar

WORKDIR $METASTORE_HOME
CMD [ "./bin/start-metastore" ]
