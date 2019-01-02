#!/bin/bash

VERSION=$1

docker build -t jeffgrunewald/presto:$VERSION .
docker push jeffgrunewald/presto:$VERSION
#sed -i -e "s#jeffgrunewald/presto:1.*#jeffgrunewald/presto:$VERSION#g" manifests/03-presto-dep.yaml
