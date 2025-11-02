# Distribution Custom Image

Custom Docker image for Distribution with dynamic configuration assembly through inline configs in docker-compose files.

## How It Works

1. Docker Compose inline configs are mounted to `/configs` directory inside the container
2. On startup, the [`entrypoint.sh`](entrypoint.sh) script finds all YAML files in `/configs`
3. Files are sorted alphabetically and merged using `yq` tool
4. The final merged configuration is written to `/etc/distribution/config.yml`
5. Distribution registry starts with the assembled configuration

## Building the Image

Build the custom Distribution image:

```bash
cd image/
docker build -t distribution:2.8.3 .
```

For local registry:

```bash
docker tag distribution:2.8.3 localhost/distribution:2.8.3
```
