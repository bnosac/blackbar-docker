FROM atkrad/wait4x:latest AS wait
FROM ollama/ollama:latest

COPY --from=wait /usr/bin/wait4x /usr/bin/
RUN chmod +x /usr/bin/wait4x

## Log in to huggingface
RUN apt update -qq \
    && apt-get update \
    && apt-get install -y python3-pip
ARG HF_TOKEN="default"
ENV HF_TOKEN=${HF_TOKEN}
RUN pip install huggingface-hub
RUN python -c 'from huggingface_hub.commands.user import _login;import os; _login(token=os.getenv("HF_TOKEN"))'
ENV HF_TOKEN="default"

ARG OLLAMA_MODEL="llama3.2"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}
RUN echo ${OLLAMA_MODEL}

#https://github.com/ollama/ollama/issues/957
RUN nohup bash -c "ollama serve &" && wait4x http http://127.0.0.1:11434 && ollama pull ${OLLAMA_MODEL}

