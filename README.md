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

   - Docker image containing Inception and Minio (blackbar-inception)
   - Docker image containing Inception and Minio and MariaDB (blackbar-inception-mariadb)

```
docker pull ghcr.io/bnosac/blackbar-inception-minio:latest
docker pull ghcr.io/bnosac/blackbar-inception-minio-mariadb:latest
```


- **blackbar-shinyproxy**:  

   - Docker image containing ShinyProxy 

```
docker pull ghcr.io/bnosac/blackbar-shinyproxy:latest
```
