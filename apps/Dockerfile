FROM ghcr.io/bnosac/blackbar-base:latest
LABEL maintainer="BNOSAC blackbar@bnosac.be"

##
## Install all Python software dependencies
##
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

##
## Install all R software dependencies
##
RUN apt update -qq \
    && apt-get install -y lsb-release \
    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    && apt-get update \
    && apt-get install -y --no-install-recommends wget libcurl4-openssl-dev libssl-dev curl bash git pkg-config \
    && apt-get install -y --no-install-recommends software-properties-common dirmngr r-base \
    && apt-get install -y --no-install-recommends r-cran-rcpp r-cran-data.table r-cran-jsonlite r-cran-zip \
    && apt-get install -y --no-install-recommends r-cran-shiny \
    && apt-get autoremove -y --quiet \
    && apt-get clean --quiet \
    && rm -rf /var/lib/apt/lists/*

CMD bash
