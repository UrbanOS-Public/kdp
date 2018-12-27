#!/bin/bash

VERSION=$1

docker build -t jeffgrunewald/hive-metastore:$VERSION .
docker push jeffgrunewald/hive-metastore:$VERSION
sed -i -e "s#jeffgrunewald/hive-metastore:1.*#jeffgrunewald/hive-metastore:$VERSION#g" manifests/03-hive-metastore-dep.yaml
