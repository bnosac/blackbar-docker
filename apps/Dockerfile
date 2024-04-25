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
    && apt-get install -y --reinstall software-properties-common dirmngr \
    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    && apt-get update \
    && apt-get install -y --no-install-recommends wget libcurl4-openssl-dev libssl-dev curl bash git pkg-config \
    && apt-get install -y --no-install-recommends r-base \
    && apt-get install -y --no-install-recommends r-cran-rcpp r-cran-data.table r-cran-jsonlite r-cran-zip \
    && apt-get install -y --no-install-recommends r-cran-shiny \
    && apt-get autoremove -y --quiet \
    && apt-get clean --quiet \
    && rm -rf /var/lib/apt/lists/*
RUN echo "\noptions(shiny.port = 3838, shiny.host = '0.0.0.0')" >> /usr/local/lib/R/etc/Rprofile.site

##
## User blackbar
##
RUN groupadd --gid 1000 shiny 
RUN useradd -c 'shiny' --uid 1000 --gid 1000 --create-home --home-dir /home/blackbar --shell /bin/bash blackbar
USER blackbar
WORKDIR /home/blackbar
EXPOSE 3838

CMD bash
