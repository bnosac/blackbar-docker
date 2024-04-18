# blackbar-docker

Public docker images for project blackbar

- **blackbar-base**:  

   - Docker image based on prefecthq/prefect, version 2.15.0-python3.10
   - Containing core software for project blackbar

```
docker pull ghcr.io/bnosac/blackbar-base:latest
```

- **blackbar-apps**:  

   - Docker image based on ghcr.io/bnosac/blackbar-base
   - Containing core software for the apps

```
docker pull ghcr.io/bnosac/blackbar-apps:latest
```
