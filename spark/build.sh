#!/bin/bash

VERSION=$1

docker build -t jeffgrunewald/scos-spark:$VERSION .
docker push jeffgrunewald/scos-spark:$VERSION
sed -i -e "s/scos-spark:1.*</scos-spark:$VERSION</" ../hive-server/manifests/01-hive-server-conf.yaml

