FROM atkrad/wait4x:latest AS wait
FROM ollama/ollama:latest

COPY --from=wait /usr/bin/wait4x /usr/bin/
RUN chmod +x /usr/bin/wait4x

ARG OLLAMA_MODEL="llama3.2"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}
RUN echo ${OLLAMA_MODEL}

#https://github.com/ollama/ollama/issues/957
RUN nohup bash -c "ollama serve &" && wait4x http http://127.0.0.1:11434 && ollama pull ${OLLAMA_MODEL}

