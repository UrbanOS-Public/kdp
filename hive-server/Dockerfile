FROM jeffgrunewald/spark-2.4-base:1.0

ARG hadoop_version=2.8.5
ARG hive_version=3.0.0
ARG spark_version=2.4.0
ARG aws_sdk_version=1.11.467

ENV HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/hive \
    SPARK_HOME=/opt/spark

RUN wget http://www.us.apache.org/dist/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
    tar zxf hadoop-${hadoop_version}.tar.gz && \
    mv hadoop-${hadoop_version} ${HADOOP_HOME} && \
    wget https://archive.apache.org/dist/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz && \
    tar zxf apache-hive-${hive_version}-bin.tar.gz && \
    mv apache-hive-${hive_version}-bin ${HIVE_HOME} && \
    rm *.tar.gz

RUN wget https://s3.us-east-2.amazonaws.com/scos-third-party-repository/aws-java-sdk/aws-java-sdk-${aws_sdk_version}.jar -P ${SPARK_HOME}/jars/ && \
    ln -s ${SPARK_HOME}/jars/aws-java-sdk-${aws_sdk_version}.jar ${HIVE_HOME}/lib/aws-java-sdk-${aws_sdk_version}.jar && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/${hadoop_version}/hadoop-aws-${hadoop_version}.jar -P ${SPARK_HOME}/jars/ && \
    ln -s ${SPARK_HOME}/jars/hadoop-aws-${hadoop_version}.jar ${HIVE_HOME}/lib/hadoop-aws-${hadoop_version}.jar && \
    rm ${SPARK_HOME}/jars/htrace-core-*.jar

RUN ln -s ${SPARK_HOME}/jars/spark-network-common_2.11-${spark_version}.jar ${HIVE_HOME}/lib/spark-network-common_2.11-${spark_version}.jar && \
    ln -s ${SPARK_HOME}/jars/scala-library-2.11.12.jar ${HIVE_HOME}/lib/scala-library-2.11.12.jar && \
    ln -s ${SPARK_HOME}/jars/spark-core_2.11-${spark_version}.jar ${HIVE_HOME}/lib/spark-core_2.11-${spark_version}.jar && \
    ln -s ${SPARK_HOME}/jars/spark-launcher_2.11-${spark_version}.jar ${HIVE_HOME}/lib/spark-launcher_2.11-${spark_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-exec-${hive_version}.jar ${SPARK_HOME}/jars/hive-exec-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-cli-${hive_version}.jar ${SPARK_HOME}/jars/hive-cli-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-common-${hive_version}.jar ${SPARK_HOME}/jars/hive-common-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-beeline-${hive_version}.jar ${SPARK_HOME}/jars/hive-beeline-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-metastore-${hive_version}.jar ${SPARK_HOME}/jars/hive-metastore-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-standalone-metastore-${hive_version}.jar ${SPARK_HOME}/jars/hive-standalone-metastore-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-jdbc-${hive_version}.jar ${SPARK_HOME}/jars/hive-jdbc-${hive_version}.jar && \
    ln -s ${HIVE_HOME}/lib/hive-jdbc-handler-${hive_version}.jar ${SPARK_HOME}/jars/hive-jdbc-handler-${hive_version}.jar && \
    rm ${SPARK_HOME}/jars/hive-*.spark2.jar


RUN rm -rf ${SPARK_HOME}/jars/{hadoop-annotations-*,hadoop-auth-*,hadoop-client-*,hadoop-common-*,hadoop-hdfs-*}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/lib/hadoop-annotations-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-annotations-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/lib/hadoop-auth-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-auth-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/client/hadoop-client-api-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-client-api-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/client/hadoop-client-minicluster-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-client-minicluster-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/client/hadoop-client-runtime-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-client-runtime-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/common/hadoop-common-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-common-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/hdfs/hadoop-hdfs-${hadoop_version}.jar ${SPARK_HOME}/jars/hadoop-hdfs-${hadoop_version}.jar && \
    ln -s ${HADOOP_HOME}/share/hadoop/hdfs/lib/htrace-core4-4.0.1-incubating.jar ${SPARK_HOME}/jars/htrace-core4-4.0.1-incubating.jar

COPY log4j.properties ${SPARK_HOME}/conf/log4j.properties
