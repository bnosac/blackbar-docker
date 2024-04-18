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

CMD bash
