#!/bin/bash

VERSION=$1

docker build -t jeffgrunewald/de-doop:$VERSION .
docker push jeffgrunewald/de-doop:$VERSION
sed -i -e "s/de-doop:1.*</de-doop:$VERSION</" manifests/01-hive-server-conf.yaml
sed -i -e "s/de-doop:1.*/de-doop:$VERSION/" manifests/03-hive-server-dep.yaml
