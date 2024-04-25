#!/bin/sh

set -e

# Execute adaptive.sh script
sh ${WSO2_SERVER_HOME}/bin/adaptive.sh "$@"

# Check the exit status
if [ $? -ne 0 ]; then
    echo "Error executing adaptive.sh"
    exit 1
fi

# Execute docker-entrypoint.sh script
sh /home/wso2carbon/docker-entrypoint.sh
