FROM atkrad/wait4x:latest as wait4x
FROM ollama/ollama:latest

COPY --from=wait4x /usr/local/bin/wait4x /usr/local/bin/wait4x
RUN chmod +x /usr/local/bin/wait4x

ARG OLLAMA_MODEL="llama3.2"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}

#RUN ollama run ${OLLAMA_MODEL}
RUN nohup bash -c "ollama serve &" && wait4x http http://127.0.0.1:11434 && ollama pull ${OLLAMA_MODEL}

