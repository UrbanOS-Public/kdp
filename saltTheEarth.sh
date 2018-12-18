#!/bin/bash

kubectl delete pods --selector=seatOf=pants
kubectl delete -f hadoop/ \
               -f hive-metastore/manifests/ \
               -f hive-server/manifests/ \
               -f postgres/ 
aws s3 rm --recursive s3://jeff-jarred-751/hive-s3/
aws s3 rm --recursive s3://jeff-jarred-751/tmp
