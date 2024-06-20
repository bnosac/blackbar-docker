FROM prefecthq/prefect:2.18.3-python3.10
LABEL maintainer="BNOSAC blackbar@bnosac.be"
LABEL org.opencontainers.image.source=https://github.com/bnosac/blackbar-docker
LABEL org.opencontainers.image.description="Anonymisation and Pseudonymisation - open libraries"
LABEL org.opencontainers.image.licenses="Apache-2.0"

##
## System requirements
##
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    libcurl4-openssl-dev \
    libssl-dev \ 
    curl \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*
##
## Install Java from eclipse-temurin (For connection to IRIS)
##
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21 ${JAVA_HOME} ${JAVA_HOME}
ENV PATH="${JAVA_HOME}/bin:${PATH}"

##
## Install all Python software dependencies
##
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

# Compatibility issues with prefect/pydantic/dkpro-cassis/attrs
#RUN python -m pip install attrs==21.2
#RUN python -m pip install attrs==23.1.0
#RUN python -m pip uninstall --yes pydantic
#RUN python -m pip install pydantic==1.10.13
#RUN python -m pip install prefect==2.14.11

####################################################################################################
## General settings
##
ARG BLACKBAR_HOME="/opt/prefect"
ENV BLACKBAR_HOME=${PREFECT_WORKSPACE}

##
## Model store settings S3 indicating where the model is stored
##
ARG BLACKBAR_S3_ENDPOINT="blackbar.datatailor.be"
ARG BLACKBAR_S3_ACCESS_KEY_ID="deid"
ARG BLACKBAR_S3_SECRET_ACCESS_KEY="provide-supersecret-key"
ARG BLACKBAR_S3_SSL_VERIFY="True"
ARG BLACKBAR_S3_MODEL_BUCKET="blackbar-models"
ARG BLACKBAR_S3_MODEL_NAME="deid_v2"
ENV BLACKBAR_S3_ENDPOINT=${BLACKBAR_S3_ENDPOINT}
ENV BLACKBAR_S3_ACCESS_KEY_ID=${BLACKBAR_S3_ACCESS_KEY_ID}
ENV BLACKBAR_S3_SECRET_ACCESS_KEY=${BLACKBAR_S3_SECRET_ACCESS_KEY}
ENV BLACKBAR_S3_SSL_VERIFY=${BLACKBAR_S3_SSL_VERIFY}
ENV BLACKBAR_S3_MODEL_BUCKET=${BLACKBAR_S3_MODEL_BUCKET}
ENV BLACKBAR_S3_MODEL_NAME=${BLACKBAR_S3_MODEL_NAME}

##
## Intersystems database
##
RUN wget https://github.com/intersystems-community/iris-driver-distribution/raw/main/JDBC/JDK18/intersystems-jdbc-3.8.0.jar --output-document=intersystems-jdbc.jar
ENV BLACKBAR_DB="InterSystems IRIS"
ENV BLACKBAR_DB_JAR=/opt/prefect/intersystems-jdbc.jar
ENV BLACKBAR_DB_URL="jdbc:IRIS://servername:port/path"
ENV BLACKBAR_DB_USER="provide-iris-user"
ENV BLACKBAR_DB_PASSWORD="provide-supersecret-password"

##
## Prefect settings 
##
# Login + indicate under which workspace this project is run
ARG PREFECT_API_KEY="provide-prefect-api-key"
ENV PREFECT_API_KEY=${PREFECT_API_KEY}
ARG PREFECT_WORKSPACE="blackbar/data-flows"
ENV PREFECT_WORKSPACE=${PREFECT_WORKSPACE}
ENV PREFECT_WORKQUEUE="blackbar-test"

##
## Inception settings 
##
ENV INCEPTION_HOST="https://inception.datatailor.be/"
ENV INCEPTION_USERNAME="remote-api"
ENV INCEPTION_PASSWORD="provide-supersecret-key"

CMD bash
