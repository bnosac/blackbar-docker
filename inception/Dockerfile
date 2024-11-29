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

COPY --from=minio /usr/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

#ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
EXPOSE 9900
EXPOSE 9901
VOLUME ["/s3"]
ENV MINIO_VOLUMES=/data

ARG BLACKBAR_S3_ACCESS_KEY_ID="deid"
ARG BLACKBAR_S3_SECRET_ACCESS_KEY="provide-supersecret-key"
ENV BLACKBAR_S3_ACCESS_KEY_ID=${BLACKBAR_S3_ACCESS_KEY_ID}
ENV BLACKBAR_S3_SECRET_ACCESS_KEY=${BLACKBAR_S3_SECRET_ACCESS_KEY}
ENV MINIO_BROWSER_REDIRECT_URL=

##
## Inception
##
EXPOSE 8080

##
## Combine Minio + Inception with supervisord
##
RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#COPY start_minio.sh /usr/bin/start_minio.sh

#CMD ["/usr/bin/supervisord", "--version"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
