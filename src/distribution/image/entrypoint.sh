#!/bin/bash
set -e

# Check if config merge is enabled
if [ "${ENABLE_CONFIG_MERGE}" != "true" ]; then
    echo "Config merge disabled (ENABLE_CONFIG_MERGE=${ENABLE_CONFIG_MERGE})"
    echo "Using existing config: ${CONFIG_FILE}"
else
    echo "Waiting for volume to be mounted at ${CONFIG_DIR}..."

    # Wait until volume is available (check every second)
    timeout=60
    counter=0
    while [ ! -d "${CONFIG_DIR}" ] && [ $counter -lt $timeout ]; do
        sleep 1
        counter=$((counter + 1))
    done

    if [ ! -d "${CONFIG_DIR}" ]; then
        echo "Warning: ${CONFIG_DIR} not found after ${timeout}s, using existing config"
    else
        echo "Merging YAML configs from ${CONFIG_DIR}..."
        
        # Find all YAML files and sort them alphabetically
        yaml_files=$(find ${CONFIG_DIR} -maxdepth 1 -type f \( -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | sort)
        
        if [ -n "$yaml_files" ]; then
            file_count=$(echo "$yaml_files" | wc -l)
            echo "Found $file_count file(s) (sorted alphabetically):"
            echo "$yaml_files"
            
            if [ "$file_count" -eq 1 ]; then
                # Only one file - just copy it
                echo "Single config file found, using it directly"
                cp "$yaml_files" ${CONFIG_FILE}
            else
                # Multiple files - merge them in alphabetical order
                echo "Merging multiple config files in alphabetical order"
                yq eval-all '. as $item ireduce ({}; . * $item)' $yaml_files > ${CONFIG_FILE}
            fi
            echo "Config processed successfully"
        else
            echo "No YAML files found in ${CONFIG_DIR}, using existing config"
        fi
    fi
fi

# Check and copy htpasswd file if needed
echo "Checking htpasswd files..."
if [ -f "${HTPASSWD_SOURCE}" ]; then
    if [ ! -f "${HTPASSWD_DEST}" ]; then
        echo "Copying ${HTPASSWD_SOURCE} to ${HTPASSWD_DEST}"
        mkdir -p "$(dirname ${HTPASSWD_DEST})"
        cp "${HTPASSWD_SOURCE}" "${HTPASSWD_DEST}"
        echo "htpasswd file copied successfully"
    else
        echo "htpasswd file already exists at ${HTPASSWD_DEST}, skipping"
    fi
else
    echo "No htpasswd source file found at ${HTPASSWD_SOURCE}"
fi

echo "Final config: ${CONFIG_FILE}"
echo "Starting registry..."

# Start registry with merged config
exec registry serve ${CONFIG_FILE}