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
RUN sudo apt update -qq \
    && sudo wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    && sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends wget libcurl4-openssl-dev libssl-dev curl bash git pkg-config \
    && sudo apt-get install -y --no-install-recommends software-properties-common dirmngr r-base \
    && sudo apt-get install -y --no-install-recommends r-cran-rcpp r-cran-data.table r-cran-jsonlite r-cran-zip \
    && sudo apt-get install -y --no-install-recommends r-cran-shiny \
    && sudo apt-get autoremove -y --quiet \
    && sudo apt-get clean --quiet \
    && sudo rm -rf /var/lib/apt/lists/*

CMD bash
