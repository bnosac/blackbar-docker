FROM openjdk:8-jre-alpine

RUN apk add --no-cache gettext

ARG SHINYPROXY_VERSION=3.0.2
ENV SHINYPROXY_VERSION=$SHINYPROXY_VERSION
ARG SHINYPROXY_INSTALL_DIR=/opt/shinyproxy
ENV SHINYPROXY_INSTALL_DIR=$SHINYPROXY_INSTALL_DIR
ARG SHINYPROXY_APP_DIR=/etc/shinyproxy
ENV SHINYPROXY_APP_DIR=$SHINYPROXY_APP_DIR

## Download ShinyProxy to /opt/shinyproxy
WORKDIR $SHINYPROXY_INSTALL_DIR
RUN wget https://www.shinyproxy.io/downloads/shinyproxy-${SHINYPROXY_VERSION}.jar -O shinyproxy.jar

## Make sure 
COPY ./entrypoint.sh init-application-yml.sh
RUN chmod +x ./init-application-yml.sh & mkdir -p $SHINYPROXY_APP_DIR
VOLUME $SHINYPROXY_APP_DIR

ENTRYPOINT ["sh", "./init-application-yml.sh"]

CMD ["java", "-jar", "shinyproxy.jar"]