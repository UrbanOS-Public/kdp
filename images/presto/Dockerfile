FROM openjdk:8-jre-slim

ARG mirror="https://repo1.maven.org/maven2/com/facebook/presto"
ARG presto_version="0.215"
ARG presto_bin="${mirror}/presto-server/${presto_version}/presto-server-${presto_version}.tar.gz"
ARG presto_cli_bin="${mirror}/presto-cli/${presto_version}/presto-cli-${presto_version}-executable.jar"

USER root

RUN apt update && \
    apt install -y --allow-unauthenticated \
        curl \
        less \
        wget && \
    apt clean && rm -rf /var/lib/apt/lists/*

ENV PRESTO_HOME=/presto
ENV PRESTO_USER=presto \
    PRESTO_CONF_DIR=${PRESTO_HOME}/etc \
    PATH=$PATH:$PRESTO_HOME/bin

RUN useradd \
	--create-home \
	--home-dir ${PRESTO_HOME} \
    --shell /bin/bash \
	$PRESTO_USER

RUN mkdir -p $PRESTO_HOME && \
    wget --quiet $presto_bin && \
    tar xzf presto-server-${presto_version}.tar.gz && \
    rm -rf presto-server-${presto_version}.tar.gz && \
    mv presto-server-${presto_version}/* $PRESTO_HOME && \
    rm -rf presto-server-${presto_version} && \
    mkdir -p ${PRESTO_CONF_DIR}/catalog/ && \
    mkdir -p ${PRESTO_HOME}/data && \
    cd ${PRESTO_HOME}/bin && \
    wget --quiet ${presto_cli_bin} && \
    mv presto-cli-${presto_version}-executable.jar presto && \
    chmod +x presto && \
    chown -R ${PRESTO_USER}:${PRESTO_USER} $PRESTO_HOME

# Need to work with python2
# See: https://github.com/prestodb/presto/issues/4678
ENV PYTHON2_DEBIAN_VERSION=2.7.13-2
RUN apt-get update && apt-get install -y --no-install-recommends \
		python="${PYTHON2_DEBIAN_VERSION}" \
	&& rm -rf /var/lib/apt/lists/* \
    && cd /usr/local/bin \
	&& rm -rf idle pydoc python python-config

USER $PRESTO_USER

CMD ["launcher", "run"]

COPY config.properties node.properties log.properties jvm.config core-site.xml ${PRESTO_CONF_DIR}/
COPY catalog ${PRESTO_CONF_DIR}/catalog
