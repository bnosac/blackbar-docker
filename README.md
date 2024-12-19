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

   - Docker image containing ShinyProxy 3.0.2 and openjdk 11 based on Debian Buster

```
docker pull ghcr.io/bnosac/blackbar-shinyproxy:latest
```

- blackbar development environments

   - **blackbar-rstudio**: Docker image containing RStudio, R 4.2.1, Python 3.10, Python packages relevant for blackbar, Java 21, based on Ubuntu 20.04
   - **blackbar-vscode**: Docker image containing Visual Studio code, R 4.2.1, Python 3.10, Python packages relevant for blackbar, Java 21, based on Ubuntu 20.04

```
docker pull ghcr.io/bnosac/blackbar-rstudio:latest
docker pull ghcr.io/bnosac/blackbar-vscode:latest
```
