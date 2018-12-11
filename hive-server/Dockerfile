FROM jeffgrunewald/spark-2.4-base:1.0

ARG hadoop_version=3.1.1
ARG hive_version=3.1.1
ARG spark_version=2.4.0

ENV HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/hive

RUN wget http://www.us.apache.org/dist/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz && \
    tar zxf hadoop-${hadoop_version}.tar.gz && \
    mv hadoop-${hadoop_version} ${HADOOP_HOME} && \
    wget http://www.us.apache.org/dist/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz && \
    tar zxf apache-hive-${hive_version}-bin.tar.gz && \
    mv apache-hive-${hive_version}-bin ${HIVE_HOME} && \
    rm *.tar.gz

RUN cd /opt/spark/jars && \
    wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop3.jar

RUN ln -s $SPARK_HOME/jars/spark-network-common_2.11-${spark_version}.jar $HIVE_HOME/lib/spark-network-common_2.11-${spark_version}.jar && \
    ln -s $SPARK_HOME/jars/scala-library-2.11.12.jar $HIVE_HOME/lib/scala-library-2.11.12.jar && \
    ln -s $SPARK_HOME/jars/spark-core_2.11-${spark_version}.jar $HIVE_HOME/lib/spark-core_2.11-${spark_version}.jar && \
    ln -s $SPARK_HOME/jars/spark-launcher_2.11-${spark_version}.jar $HIVE_HOME/lib/spark-launcher_2.11-${spark_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-exec-${hive_version}.jar $SPARK_HOME/jars/hive-exec-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-cli-${hive_version}.jar $SPARK_HOME/jars/hive-cli-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-common-${hive_version}.jar $SPARK_HOME/jars/hive-common-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-beeline-${hive_version}.jar $SPARK_HOME/jars/hive-beeline-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-metastore-${hive_version}.jar $SPARK_HOME/jars/hive-metastore-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-standalone-metastore-${hive_version}.jar $SPARK_HOME/jars/hive-standalone-metastore-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-jdbc-${hive_version}.jar $SPARK_HOME/jars/hive-jdbc-${hive_version}.jar && \
    ln -s $HIVE_HOME/lib/hive-jdbc-handler-${hive_version}.jar $SPARK_HOME/jars/hive-jdbc-handler-${hive_version}.jar && \
    rm $SPARK_HOME/jars/hive-*.spark2.jar

COPY log4j.properties /opt/spark/conf/log4j.properties
COPY spark-defaults.conf /opt/spark/conf/spark-defaults.conf