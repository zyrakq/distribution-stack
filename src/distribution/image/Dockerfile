ARG VERSION=2.8.3
FROM distribution/distribution:${VERSION}

# Install yq for YAML merging
RUN apk add --no-cache yq bash

# Environment variables for configuration
ENV CONFIG_DIR=/configs
ENV CONFIG_FILE=/etc/distribution/config.yml
ENV ENABLE_CONFIG_MERGE=true
ENV HTPASSWD_SOURCE=/tmp/.htpasswd
ENV HTPASSWD_DEST=/auth/.htpasswd

# Create directory for configs
RUN mkdir -p ${CONFIG_DIR} /auth

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]