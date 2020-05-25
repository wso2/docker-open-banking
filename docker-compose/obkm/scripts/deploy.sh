#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2020 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

set -e

ECHO=`which echo`
GREP=`which grep`
DOCKER_CLIENT=`which docker`
DOCKER_COMPOSE_CLIENT=`which docker-compose`
SED=`which sed`
TEST=`which test`

# # methods
function echoBold () {
    ${ECHO} -e $'\e[1m'"${1}"$'\e[0m'
}

echo "Configured Open Banking SG specification..."

read -p "Enter Your WSO2 Username: " WSO2_SUBSCRIPTION_USERNAME
${ECHO}
read -s -p "Enter Your WSO2 Password: " WSO2_SUBSCRIPTION_PASSWORD
${ECHO}
${ECHO}
echoBold "Logging into WSO2 Private Docker Registry (docker.wso2.com)"
${ECHO}
${DOCKER_CLIENT} login --username ${WSO2_SUBSCRIPTION_USERNAME} --password ${WSO2_SUBSCRIPTION_PASSWORD} docker.wso2.com

# remove backed up files
${TEST} -f ../*.bak && rm ../*.bak

cd ..

${DOCKER_COMPOSE_CLIENT} up -d

echoBold "Once the servers have finished loading,
To access the Management Console of WSO2 Open Banking Key Manager, use https://localhost:9446/carbon.

To list the created WSO2 product server containers, use \`docker ps\` Docker client command.
For instructions to delete the created WSO2 product server setup, please see the Docker Compose FAQ (https://wso2.com/products/install/faq/#iDocker)."
