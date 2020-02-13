FROM minio/minio:RELEASE.2020-02-07T23-28-16Z

RUN apk add inotify-tools

COPY kdp /kdp

ENTRYPOINT []

CMD ["/kdp/start-minio.sh"]
