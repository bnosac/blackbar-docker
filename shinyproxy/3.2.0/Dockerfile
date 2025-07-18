FROM openanalytics/shinyproxy:3.2.0 AS shinyproxy
FROM public.ecr.aws/docker/library/eclipse-temurin:21-jammy

RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y gettext \
    && apt-get install -y curl 

## Copy over shinyproxy.jar from the official shinyproxy repository
RUN mkdir /opt/shinyproxy
ENV SHINY_USER blackbar
RUN useradd -c 'blackbar user' -m -d /home/$SHINY_USER -s /sbin/nologin $SHINY_USER
COPY --from=shinyproxy --chown=$SHINY_USER:$SHINY_USER /opt/shinyproxy/ /opt/shinyproxy/

## Entrypoint is shell script which overwrites the applications  
ENV SHINYPROXY_APPLICATION_DIR /home/$SHINY_USER/apps

ADD ./entrypoint.sh /opt/shinyproxy/init-application-yml.sh
RUN chmod +x /opt/shinyproxy/init-application-yml.sh
ENTRYPOINT ["sh", "/opt/shinyproxy/init-application-yml.sh"]

WORKDIR /opt/shinyproxy
USER $SHINY_USER

EXPOSE 8080

# Start ShinyProxy with some extra parameters for faster startup (https://spring.io/blog/2018/11/08/spring-boot-in-a-container#tweaks)
CMD ["java",  "-jar", "/opt/shinyproxy/shinyproxy.jar", "--spring.jmx.enabled=false", "--spring.config.location=/opt/shinyproxy/application.yml"]
