FROM openjdk:8-jdk AS kyloBuilder

ARG UID=1000
ARG GID=1000
ARG kylo_version=0.10.0

ENV JAVA_OPTS="-Xms512M -Xmx1536M" \
    MAVEN_OPTS="${JAVA_OPTS}" \
    MAVEN_SKIP_RC="true"

USER root

RUN apt update && \
    apt install -y \
    maven \
    rpm

RUN git clone https://github.com/teradata/kylo.git /opt/kylo && \
    cd /opt/kylo && \
    git checkout tags/v${kylo_version} && \
    mvn clean install -DskipTests

RUN cd /opt/kylo && \
    mkdir install/install-tar/target/kylo && \
    tar -C install/install-tar/target/kylo -xvf install/install-tar/target/kylo-*-dependencies.tar.gz && \
    mkdir -p /opt/nifi/data/lib/app && \
    cp -a install/install-tar/target/kylo/setup/nifi/. /opt/nifi/data/lib && \
    mv /opt/nifi/data/lib/kylo-spark-*.jar /opt/nifi/data/lib/app

#######

FROM apache/nifi:1.8.0

ARG UID=1000
ARG GID=1000
ARG activemq_version=5.15.8
ARG impala_driver_version=2.6.4.1005
ARG mariadb_client_version=2.3.0
ARG nifi_version=1.8.0
ARG pg_driver_version=42.2.5
ARG spark_version=2.4.0

ENV JAVA_OPTS="-Xms512M -Xmx1536M"

COPY --from=kyloBuilder /opt/nifi/data/lib /opt/nifi/data/lib

USER root

SHELL ["/bin/bash", "-c"]
RUN mkdir -p /opt/nifi/{activemq,drivers,nifi-${nifi_version}/lib/app,dump} && \
    mkdir -p /opt/fake_data && \
    mkdir -p /var/dropzone && \
    chown -R nifi:nifi /opt/fake_data /var/dropzone && \
    ln -f -s /opt/nifi/nifi-${nifi_version} /opt/nifi/current

RUN cd /opt && wget -q https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz && \
    tar -xzf spark-${spark_version}-bin-hadoop2.7.tgz && \
    ln -s spark-${spark_version}-bin-hadoop2.7 spark && \
    rm *.tgz && \
    mkdir -p /opt/spark/lib

ENV PATH=$PATH:/opt/spark/bin

RUN /opt/nifi/data/lib/create-symbolic-links.sh /opt/nifi nifi nifi && \
    wget -q http://central.maven.org/maven2/org/apache/activemq/activemq-all/${activemq_version}/activemq-all-${activemq_version}.jar -P /opt/nifi/activemq/ && \
    wget -q http://central.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/${mariadb_client_version}/mariadb-java-client-${mariadb_client_version}.jar -P /opt/nifi/drivers && \
    wget -q https://jdbc.postgresql.org/download/postgresql-${pg_driver_version}.jar -P /opt/spark/jars/

RUN wget -q https://downloads.cloudera.com/connectors/impala_jdbc_${impala_driver_version}.zip && \
    unzip impala_jdbc_${impala_driver_version}.zip && \
    rm impala_jdbc_${impala_driver_version}.zip && \
    unzip ClouderaImpalaJDBC-${impala_driver_version}/ClouderaImpalaJDBC4-${impala_driver_version}.zip && \
    mkdir -p /opt/nifi/drivers/impala && \
    mv ImpalaJDBC4.jar /opt/nifi/drivers/impala/ && \
    rm -r ClouderaImpalaJDBC-${impala_driver_version}

EXPOSE 8080 8443 10000
