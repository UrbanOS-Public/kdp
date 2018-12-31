#!/usr/bin/env bash
set -e

# TODO - this should be done through spark-shell --packages parameter, however, we were running into issues with that so here are
cd /opt/spark/jars \
  && curl -O https://search.maven.org/remotecontent?filepath=org/apache/hadoop/hadoop-aws/2.6.5/hadoop-aws-2.6.5.jar \
  && curl -O https://search.maven.org/remotecontent?filepath=com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar