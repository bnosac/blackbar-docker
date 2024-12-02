FROM minio/minio:latest AS minio
#FROM ghcr.io/inception-project/inception:34.3 AS inception
FROM ghcr.io/inception-project/inception:28.5 AS inception
FROM mariadb:10.7

############################################################################################
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
EXPOSE 9000
EXPOSE 9001
VOLUME ["/s3"]
ENV MINIO_VOLUMES=/data

# Passwords for the admin user
ARG BLACKBAR_S3_ACCESS_KEY_ID="admin"
ARG BLACKBAR_S3_SECRET_ACCESS_KEY="provide-supersecret-key"
ENV BLACKBAR_S3_ACCESS_KEY_ID=${BLACKBAR_S3_ACCESS_KEY_ID}
ENV BLACKBAR_S3_SECRET_ACCESS_KEY=${BLACKBAR_S3_SECRET_ACCESS_KEY}
# If behind reverse proxy
ENV MINIO_BROWSER_REDIRECT_URL=

############################################################################################
## Inception
##
RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y openjdk-11-jdk
WORKDIR /opt/inception
COPY --from=inception /opt/inception/inception-app-standalone.jar /opt/inception/inception-app-standalone.jar

EXPOSE 8080
ARG INCEPTION_HOST=http://localhost:8080
ENV INCEPTION_HOST=${INCEPTION_HOST}
## Settings for the admin username and password
ARG INCEPTION_USERNAME="admin"
ARG INCEPTION_PASSWORD="provide-supersecret-key"
ENV INCEPTION_USERNAME=${INCEPTION_USERNAME}
ENV INCEPTION_PASSWORD=${INCEPTION_PASSWORD}

## Settings for the metadata database behind Inception, 
##   if INCEPTION_DB_URL not provided, connect to internal MariaDB, if you set INCEPTION_DB_DRIVER to internal, uses HyperSQL
##   if INCEPTION_DB_URL is provided: use an external MariaDB/MySQL
ENV INCEPTION_DB_URL=
ENV INCEPTION_DB_USERNAME=inception
ENV INCEPTION_DB_PASSWORD=${INCEPTION_PASSWORD}
ENV INCEPTION_DB_DIALECT=org.hibernate.dialect.MariaDB106Dialect
ENV INCEPTION_DB_DRIVER=org.mariadb.jdbc.Driver

##
## Mariadb
##
RUN cp /usr/local/bin/healthcheck.sh /usr/bin/healthcheck-mariadb.sh
RUN cp /usr/local/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint-mariadb.sh
## For the MariaDB allow root
ARG MARIADB_MYSQL_SOCKET_DIRECTORY='/var/run/mysqld'
RUN mkdir -p $MARIADB_MYSQL_SOCKET_DIRECTORY && \
    chown root:mysql $MARIADB_MYSQL_SOCKET_DIRECTORY && \
    chmod 774 $MARIADB_MYSQL_SOCKET_DIRECTORY

############################################################################################
## Combine Minio + Inception / MariaDB with supervisord
##   apache2-utils for generating a bcrypted version of the INCEPTION_PASSWORD
##
RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y supervisor \
    && apt-get install -y apache2-utils

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start_inception.sh /usr/bin/start_inception.sh
RUN chmod +x /usr/bin/start_inception.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
