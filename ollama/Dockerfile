FROM ollama/ollama:latest
ARG OLLAMA_MODEL="llama3.2"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}

#RUN ollama run ${OLLAMA_MODEL}
RUN nohup bash -c "ollama serve &" && wait4x http http://127.0.0.1:11434 && ollama pull ${OLLAMA_MODEL}

