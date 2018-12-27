#! /bin/bash

kubectl apply -f hadoop/ \
              -f hive-metastore/manifests/ \
              -f hive-server/manifests/ \
              -f postgres/
