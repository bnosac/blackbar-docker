FROM minio/minio:latest AS minio
#FROM ghcr.io/inception-project/inception:34.3
FROM ghcr.io/inception-project/inception:28.5

##
## Minio
##
RUN chmod -R 777 /usr/bin

COPY --from=minio /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=minio /usr/bin/minio* /usr/bin/
COPY --from=minio /usr/bin/mc* /usr/bin/
COPY --from=minio /usr/bin/curl* /usr/bin/

COPY --from=minio /licenses/CREDITS /licenses/CREDITS
COPY --from=minio /licenses/LICENSE /licenses/LICENSE

#COPY --from=minio /usr/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

#ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
EXPOSE 9900
EXPOSE 9901
VOLUME ["/s3"]
ENV MINIO_VOLUMES=/data

ARG BLACKBAR_S3_ACCESS_KEY_ID="admin"
ARG BLACKBAR_S3_SECRET_ACCESS_KEY="provide-supersecret-key"
ENV BLACKBAR_S3_ACCESS_KEY_ID=${BLACKBAR_S3_ACCESS_KEY_ID}
ENV BLACKBAR_S3_SECRET_ACCESS_KEY=${BLACKBAR_S3_SECRET_ACCESS_KEY}
ENV MINIO_BROWSER_REDIRECT_URL=

##
## Inception
##
EXPOSE 8080
ARG INCEPTION_HOST=http://localhost:8080
ARG INCEPTION_USERNAME="admin"
ARG INCEPTION_PASSWORD="provide-supersecret-key"
ENV INCEPTION_HOST=${INCEPTION_HOST}
ENV INCEPTION_USERNAME=${INCEPTION_USERNAME}
ENV INCEPTION_PASSWORD=${INCEPTION_PASSWORD}
## Settings for the metadata database behind Inception
ENV INCEPTION_DB_URL=
ENV INCEPTION_DB_USERNAME=
ENV INCEPTION_DB_PASSWORD=
ENV INCEPTION_DB_DIALECT=
ENV INCEPTION_DB_DRIVER=

##
## Combine Minio + Inception with supervisord
##
RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y supervisor \
    && apt-get install -y apache2-utils

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start_minio.sh /usr/bin/start_minio.sh
COPY start_inception.sh /usr/bin/start_inception.sh
COPY start_mariadb.sh /usr/bin/start_mariadb.sh
RUN chmod +x /usr/bin/start_minio.sh
RUN chmod +x /usr/bin/start_inception.sh
RUN chmod +x /usr/bin/start_mariadb.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
