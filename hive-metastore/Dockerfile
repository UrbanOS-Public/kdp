FROM java:8u111-jre

ENV METASTORE_HOME=/usr/local/hive-metastore \
    HADOOP_HOME=/usr/local/hadoop

RUN apt update && apt install -y vim
RUN wget http://apache.claz.org/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz && \
 tar zxf hadoop-3.1.1.tar.gz && \
 mv hadoop-3.1.1 /usr/local/hadoop && \
 wget http://apache.claz.org/hive/hive-standalone-metastore-3.0.0/hive-standalone-metastore-3.0.0-bin.tar.gz && \
 tar zxf hive-standalone-metastore-3.0.0-bin.tar.gz && \
 mv apache-hive-metastore-3.0.0-bin $METASTORE_HOME && \
 rm *.tar.gz

COPY metastore-site.xml $METASTORE_HOME/conf/metastore-site.xml

RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.5.jar --output-document=$METASTORE_HOME/lib/postgres-42.2.5.jar

# ./schematool -dbType postgres -initSchema => run as initContainer in Helm or similar

WORKDIR $METASTORE_HOME
CMD [ "./bin/start-metastore" ]
