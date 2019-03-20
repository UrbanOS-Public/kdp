FROM 199837183662.dkr.ecr.us-east-2.amazonaws.com/scos/presto:latest

COPY config.properties node.properties log.properties jvm.config core-site.xml ${PRESTO_CONF_DIR}/
COPY catalog ${PRESTO_CONF_DIR}/catalog
