#!/bin/bash

VERSION=$1

docker build -t jeffgrunewald/nifi:$VERSION .
docker push jeffgrunewald/nifi:$VERSION
sed -i -e "s#jeffgrunewald/nifi:1.*#jeffgrunewald/nifi:$VERSION#g" manifests/03-nifi-dep.yaml
