FROM openjdk:8-jdk AS kyloBuilder

ARG UID=1000
ARG GID=1000

ENV JAVA_OPTS="-Xms512M -Xmx1536M" \
    MAVEN_OPTS="${JAVA_OPTS}" \
    MAVEN_SKIP_RC="true"

USER root

RUN apt update && \
    apt install -y \
    maven \
    rpm

RUN git clone https://github.com/teradata/kylo.git /opt/kylo && \
