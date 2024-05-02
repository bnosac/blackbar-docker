FROM openanalytics/shinyproxy:3.0.2

ARG SHINYPROXY_VERSION=3.0.2
ENV SHINYPROXY_VERSION=$SHINYPROXY_VERSION
ARG SHINYPROXY_INSTALL_DIR=/opt/shinyproxy
ENV SHINYPROXY_INSTALL_DIR=$SHINYPROXY_INSTALL_DIR
ARG SHINYPROXY_APPLICATION_DIR=/etc/shinyproxy
ARG SHINYPROXY_APPLICATION_DIR=/home/blackbar
ENV SHINYPROXY_APPLICATION_DIR=$SHINYPROXY_APPLICATION_DIR

##
## Create group blackbar
## Create user blackbar with own home directory
## Add user shinyproxy to group blackbar
##
USER root
RUN groupadd --gid 1001 blackbar \
    && useradd -c 'shiny' -g 1001 --create-home --home-dir /home/blackbar --shell /bin/bash blackbar \
    && usermod --append --groups blackbar shinyproxy \
    && usermod --append --groups blackbar blackbar \
    && mkdir /opt/shinyproxy/blackbar \
    && chown -R shinyproxy:blackbar /opt/shinyproxy/blackbar \
    && chgrp -R blackbar /opt/shinyproxy/blackbar \
    && chmod -R g+rwX /opt/shinyproxy/blackbar

## Script init-application-yml.sh makes sure application.yml is put from ${SHINYPROXY_APPLICATION_DIR}/application.yml to ${SHINYPROXY_INSTALL_DIR}/application.yml 
## Runs shinyproxy from the SHINYPROXY_INSTALL_DIR
## #COPY ./entrypoint.sh /opt/shinyproxy/init-application-yml.sh
ADD ./entrypoint.sh /opt/shinyproxy/init-application-yml.sh
RUN chmod +x /opt/shinyproxy/init-application-yml.sh
ENTRYPOINT ["sh", "/opt/shinyproxy/init-application-yml.sh"]

## Run script init-application-yml.sh as user shinyproxy and run shinyproxy as user shinyproxy
USER shinyproxy
CMD ["java", "-noverify",  "-jar", "/opt/shinyproxy/shinyproxy.jar", "--spring.jmx.enabled=false", "--spring.config.location=/opt/shinyproxy/application.yml"]