FROM minio/minio:latest AS minio
#FROM ghcr.io/inception-project/inception:34.3
FROM ghcr.io/inception-project/inception:31.0
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

##
## Inception
##
EXPOSE 8080

##
## Combine Minio + Inception
##
RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y supervisor
ENV MINIO_ROOT_USER=admin
ENV MINIO_ROOT_PASSWORD=admin
#ENV MINIO_BROWSER_REDIRECT_URL="https://deid.datatailor.be/s3/"
#ENV MINIO_ACCESS_KEY=${MINIO_ROOT_USER:-blackbar}
#ENV MINIO_SECRET_KEY=${MINIO_ROOT_PASSWORD:-blackbar}
ENV MINIO_VOLUMES=/s3
#ENV MINIO_OPTS="--console-address :9901"

#CMD ["minio server"]
#CMD /usr/bin/minio server /data --console-address ":9901"
#CMD minio server /data --console-address ":9901" && /opt/inception/launch.sh java ${JAVA_MEMORY_OPTS} ${JAVA_OPTS} -Djava.awt.headless=true -Dinception.home=/export -jar inception-app-standalone.jar ${INCEPTION_ARGUMENTS}
CMD /opt/inception/launch.sh java ${JAVA_MEMORY_OPTS} ${JAVA_OPTS} -Djava.awt.headless=true -Dinception.home=/export -jar inception-app-standalone.jar ${INCEPTION_ARGUMENTS}\
  && minio server --address ":9900" --console-address ":9901"
