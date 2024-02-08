FROM prefecthq/prefect:2.14.12-python3.11
LABEL maintainer="BNOSAC blackbar@bnosac.be"
# Model store settings
ARG BLACKBAR_S3_ENDPOINT="blackbar.datatailor.be"
ARG BLACKBAR_S3_ACCESS_KEY_ID="deid"
ARG BLACKBAR_S3_SECRET_ACCESS_KEY="provide-supersecret-key"
## System requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \ 
    curl \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*
CMD bash