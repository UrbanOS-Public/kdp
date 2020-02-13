#!/usr/bin/env sh
# WHY?!?!
## Hive cannot drop an empty folder as part of a drop table
## S3 handles this in some mysterious way
## Minio does not
## This makes minio act in an equally mysterious way that works
set -x

mkdir -p /kdp/kdp-cloud-storage/hive-s3/

# Watches for new directories
inotifywait -m /kdp/kdp-cloud-storage/hive-s3/ -e create \
| while read parent_directory action new_directory; do
  if [ "${action}" == "CREATE,ISDIR" ]; then
    # Makes a 0-byte file as a placeholder
    touch ${parent_directory}${new_directory}/.placeholder
  fi
done
