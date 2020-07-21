FROM metastore:build

COPY metastore-site.xml ${METASTORE_HOME}/conf/metastore-site.xml
COPY core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site.xml

ENV HADOOP_OPTS -server \
  -Xmx768M \
  -XX:+UseG1GC \
  -XX:G1HeapRegionSize=32M \
  -XX:+UseGCOverheadLimit \
  -XX:+ExplicitGCInvokesConcurrent \
  -XX:+HeapDumpOnOutOfMemoryError \
  -XX:+ExitOnOutOfMemoryError