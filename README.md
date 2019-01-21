# Kubernets-Data-Platform

Big data platform components without Hadoop (HDFS, name services, etc.)

## Hive / Metastore

Creates the hive metastore service to provide metadata services for both Hive and PrestoDB.

https://github.com/apache/hive

## Minio

Creates optional S3-compatible object store, chiefly for local development.

https://github.com/minio/minio

## Presto

Abstraction layer for querying structured data of varying types with varying backends. Includes Hive tables (managed by Hive Metastore), Cassandra, local files, etc.

https://github.com/prestodb/presto

## Spark

Provides a Docker image definition for running spark workloads dynamically against the kubernetes cluster, or to pass to Hive for running hive insert queries (via the hive-site.xml settings).