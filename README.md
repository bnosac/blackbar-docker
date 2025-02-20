# blackbar-docker

Public docker images for project blackbar

- **blackbar-base**:  

   - Docker image based on prefecthq/prefect, version 2.15.0-python3.10 which is based on Ubuntu 20.04
   - Containing core software for project blackbar

```
docker pull ghcr.io/bnosac/blackbar-base:latest
```

- **blackbar-base-apps**:  

   - Docker image based on ghcr.io/bnosac/blackbar-base
   - Containing core software for the webapps

```
docker pull ghcr.io/bnosac/blackbar-base-apps:latest
```

- **blackbar-inception**:  

   - Docker image containing Inception and Minio (blackbar-inception-minio)
   - Docker image containing Inception and Minio and MariaDB (blackbar-inception-minio-mariadb)

Inception 28.5, Minio RELEASE.2024-11-07T00-52-20Z, MariaDB 10.7

```
docker pull ghcr.io/bnosac/blackbar-inception-minio:latest
docker pull ghcr.io/bnosac/blackbar-inception-minio-mariadb:latest
```


- **blackbar-shinyproxy**:  

   - **blackbar-shinyproxy-3.1.1**: Docker image containing ShinyProxy 3.1.1 and Java 17 based on Ubuntu Jammy (eclipse-temurin:17-jammy)
   - **blackbar-shinyproxy-3.0.2**: Docker image containing ShinyProxy 3.0.2 and Java 11 based on Debian Buster (openjdk:11-jre-slim-buster)

```
docker pull ghcr.io/bnosac/blackbar-shinyproxy-3.1.1:latest
docker pull ghcr.io/bnosac/blackbar-shinyproxy-3.0.2:latest
```

- blackbar development environments

   - **blackbar-rstudio**: Docker image containing RStudio, R 4.2.1, Python 3.10, Python packages relevant for blackbar, Java 21, based on Ubuntu 20.04
   - **blackbar-vscode**: Docker image containing Visual Studio code, R 4.2.1, Python 3.10, Python packages relevant for blackbar, Java 21, based on Ubuntu 20.04

```
docker pull ghcr.io/bnosac/blackbar-rstudio:latest
docker pull ghcr.io/bnosac/blackbar-vscode:latest
```

- **blackbar-ollama**:  

   - **blackbar-ollama-llama3.2**: Docker image containing Ollama with Deepllama 3b: https://ollama.com/library/llama3.2:3b
   - **blackbar-ollama-deepseek-r1-14b-qwen-distill-q4**: Docker image containing Ollama with Deepseek 14b distilled to Qwen: https://ollama.com/library/deepseek-r1:14b-qwen-distill-q4_K_M
   - **blackbar-ollama-deepscaler-1.5b-preview-q8_0**: Docker image containing Ollama with Deepscaler 1.5b preview: https://ollama.com/library/deepscaler:1.5b-preview-q8_0

