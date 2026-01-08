FROM atkrad/wait4x:latest AS wait
FROM ollama/ollama:latest
COPY --from=wait /usr/bin/wait4x /usr/bin/
RUN chmod +x /usr/bin/wait4x

ARG OLLAMA_MODEL="llama3.2"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}

# Start ollama, pull model, verify it's there, then cleanup
RUN (ollama serve &) && \
    OLLAMA_PID=$! && \
    wait4x http http://127.0.0.1:11434 --timeout 120s --interval 2s && \
    sleep 3 && \
    ollama pull ${OLLAMA_MODEL} && \
    ollama list && \
    sleep 5 && \
    kill -TERM $OLLAMA_PID && \
    wait $OLLAMA_PID || true