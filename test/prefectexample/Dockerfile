FROM prefecthq/prefect:2.14.20-python3.10
LABEL maintainer="BNOSAC blackbar@bnosac.be"

# General settings
ARG BLACKBAR_SCHEDULER="prefect"

# Model store settings
ARG BLACKBAR_S3_ENDPOINT="blackbar.datatailor.be"
ARG BLACKBAR_S3_ACCESS_KEY_ID="deid"
ARG BLACKBAR_S3_SECRET_ACCESS_KEY="provide-supersecret-key"

##
## Prefect settings 
##
# Login + indicate under which workspace this project is run
ARG PREFECT_API_KEY="provide-prefect-api-key"
ARG PREFECT_WORKSPACE="blackbar/data-flows"
RUN echo 'cloud' | prefect cloud login --key ${PREFECT_API_KEY} --workspace ${PREFECT_WORKSPACE}
# Work queue to listen to tasks to execute
ENV PREFECT_WORKQUEUE="blackbar-test"

## System requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \ 
    curl \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*

# Get the model

# Install all software
COPY requirements.txt .
RUN python -m pip install -r requirements.txt
RUN echo "Finished installation of python package"

# Upgrade prefect to the latest version
# RUN python -m pip install prefect

# Test
ENV TEST=${PREFECT_WORKSPACE}

# Get Python code to schedule
COPY deployment.py /opt/prefect/flows/deployment.py

# Create the Deployment + start an agent to listen to tasks in the workqueue
CMD python flows/deployment.py && prefect agent start --work-queue ${PREFECT_WORKQUEUE}
