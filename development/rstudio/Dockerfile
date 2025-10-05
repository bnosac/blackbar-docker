## Ubuntu 24.04 with RStudio
FROM ghcr.io/rocker-org/rstudio:4.5.0

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
    acl \
    pkg-config \
    software-properties-common \
    cmake \
    && rm -rf /var/lib/apt/lists/*

##
## Install Java 21 from eclipse-temurin (For connection to IRIS)
##
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21 ${JAVA_HOME} ${JAVA_HOME}
ENV PATH="${JAVA_HOME}/bin:${PATH}"

##
## Intersystems database
##
RUN wget https://github.com/intersystems-community/iris-driver-distribution/raw/main/JDBC/JDK18/intersystems-jdbc-3.8.0.jar --output-document=intersystems-jdbc.jar

##
## Install uv
## Install Python 3.10 and Python package dependencies
##
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3.10 python3.10-dev python3.10-distutils \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && update-alternatives --config python3
COPY requirements.txt .
#RUN python3.10 -m pip install --no-cache-dir -r requirements.txt
#RUN python3    -m pip install --no-cache-dir -r requirements.txt
RUN uv pip install --system --no-cache-dir -r requirements.txt
RUN uv pip install --system pip

##
## Default R packages
##
ENV RETICULATE_PYTHON="/usr/bin/python3"
RUN Rscript -e "install.packages(c('curl', 'openssl', 'remotes', 'httr'), clean = TRUE)"
RUN Rscript -e "install.packages(c('jsonlite', 'yaml', 'zip', 'data.table', 'Rcpp', 'reticulate'), clean = TRUE)"
RUN Rscript -e "install.packages(c('shiny', 'knitr', 'htmltools', 'markdown', 'rmarkdown', 'shinydashboard', 'flexdashboard', 'bslib', 'fontawesome', 'sass', 'farver', 'DT'), clean = TRUE)"

##
## Rstudio initializations
##
# NB: this file is only used by rocker if the env var DISABLE_AUTH: true is specified in the application.yml
RUN echo "www-frame-origin=same"   >> /etc/rstudio/disable_auth_rserver.conf
RUN echo "www-verify-user-agent=0" >> /etc/rstudio/disable_auth_rserver.conf
ADD 03_setup_root_path.sh /etc/cont-init.d/03_setup_root_path.sh
ADD 04_copy_env.sh        /etc/cont-init.d/04_copy_env.sh
