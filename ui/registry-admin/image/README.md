# Registry Admin Custom Image

Custom Docker image for Registry Admin with dynamic configuration generation based on environment variables.

## Quick Start

Build the custom Vela Chat image:

```bash
cd src/image
docker build -t registry-admin .
docker tag registry-admin localhost/registry-admin
```
