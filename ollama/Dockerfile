FROM ollama/ollama:latest
ARG OLLAMA_MODEL="llama3.2"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}

RUN ollama pull ${OLLAMA_MODEL}
