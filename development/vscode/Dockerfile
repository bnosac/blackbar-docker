## Ubuntu 20.04 VS Code Server
FROM ghcr.io/rocker-org/rstudio:4.2.1 AS rstudio

## Common utitilities + dependencies for handling audio + OpenBLAS
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget libcurl4-openssl-dev libssl-dev curl bash git \
    && apt-get install -y --no-install-recommends pkg-config libopenblas-dev libavfilter-dev software-properties-common dirmngr \
    && apt-get autoremove -y --quiet \
    && apt-get clean --quiet \
    && rm -rf /var/lib/apt/lists/*

FROM codercom/code-server:4.95.2-focal

USER root

ENV CRAN="https://p3m.dev/cran/__linux__/focal/latest"
ENV LANG=en_US.UTF-8
ENV R_VERSION="4.2.1"
ENV R_HOME="/usr/local/lib/R"
ENV TZ="Etc/UTC"

COPY  --from=rstudio /rocker_scripts/bin/ /rocker_scripts/bin/
COPY  --from=rstudio /rocker_scripts/install_R_source.sh /rocker_scripts/install_R_source.sh
COPY  --from=rstudio /rocker_scripts/install_rstudio.sh /rocker_scripts/install_rstudio.sh
COPY  --from=rstudio /rocker_scripts/install_s6init.sh /rocker_scripts/install_s6init.sh
COPY  --from=rstudio /rocker_scripts/default_user.sh /rocker_scripts/default_user.sh
COPY  --from=rstudio /rocker_scripts/init_set_env.sh /rocker_scripts/init_set_env.sh
COPY  --from=rstudio /rocker_scripts/init_userconf.sh /rocker_scripts/init_userconf.sh
COPY  --from=rstudio /rocker_scripts/pam-helper.sh /rocker_scripts/pam-helper.sh
COPY  --from=rstudio /rocker_scripts/install_pandoc.sh /rocker_scripts/install_pandoc.sh
COPY  --from=rstudio /rocker_scripts/install_quarto.sh /rocker_scripts/install_quarto.sh

COPY  --from=rstudio /rocker_scripts/bin/ /rocker_scripts/bin/
COPY  --from=rstudio /rocker_scripts/setup_R.sh /rocker_scripts/setup_R.sh
RUN /rocker_scripts/install_R_source.sh
#RUN /rocker_scripts/setup_R.sh

## Add a default CRAN mirror
RUN echo "options(repos = c(CRAN = '${CRAN}'), download.file.method = 'libcurl')" >>"${R_HOME}/etc/Rprofile.site"
RUN echo "options(HTTPUserAgent = sprintf('R/%s R (%s)', getRversion(), paste(getRversion(), R.version['platform'], R.version['arch'], R.version['os'])))" >> "${R_HOME}/etc/Rprofile.site"

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh


##
## System requirements
##
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
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
ENV CMAKE_ARGS="-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS"
RUN uv pip install --system --no-cache-dir llama-cpp-python
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

RUN useradd --create-home --home-dir /home/blackbar --shell /bin/bash blackbar
RUN mv ./intersystems-jdbc.jar /home/blackbar/intersystems-jdbc.jar
RUN chown blackbar /home/blackbar/intersystems-jdbc.jar
RUN Rscript -e "install.packages(c('languageserver'), clean = TRUE)"
USER blackbar
#USER coder

##
## Install VScode extensions
##
RUN code-server --install-extension Posit.shiny
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter
RUN code-server --install-extension quarto.quarto
RUN code-server --install-extension REditorSupport.r
RUN code-server --install-extension ms-azuretools.vscode-docker
