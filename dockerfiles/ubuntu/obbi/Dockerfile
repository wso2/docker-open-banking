# ----------------------------------------------------------------------------------------
#
# Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# ----------------------------------------------------------------------------------------

ARG BASE_DOCKER_IMAGE_REGISTRY="docker.wso2.com"
ARG BASE_PRODUCT_VERSION=4.0.0.0

# set base Docker image to WSO2 Streaming Integrator Ubuntu Docker image
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2si:${BASE_PRODUCT_VERSION}
LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v3.0.0.8"

# set Docker image build arguments
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME=wso2si
ARG WSO2_SERVER_VERSION=4.0.0
ARG WSO2_OB_ACCELERATOR_NAME=wso2-obbi-accelerator
ARG WSO2_OB_ACCELERATOR_VERSION=3.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_OB_ACCELERATOR=${WSO2_OB_ACCELERATOR_NAME}-${WSO2_OB_ACCELERATOR_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}
ARG WSO2_OB_Accelerator_DIST_URL
ARG WSO2_OB_KEYSTORES_URL
# build argument for MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of The WSO2 Open Banking Solution, with its latest GA release \n\
which is under The WSO2 Commercial License 1.0. \n\
Read more about The WSO2 Commercial License, Version 1.0 here @ http://wso2.com/licenses \n"

# configuration properties for deployment.toml file
# server hostnames
ARG IS_HOSTNAME=localhost
ARG APIM_HOSTNAME=localhost
ARG BI_HOSTNAME=localhost
# databases related properties
ARG DB_TYPE=mysql
ARG DB_USER=root
ARG DB_PASS=root
ARG DB_HOST=mysql
ARG DB_DRIVER=com.mysql.jdbc.Driver
ARG DB_APIMGT=openbank_apimgtdb
ARG DB_USER_STORE=openbank_userdb
ARG DB_AM_CONFIG=openbank_am_configdb
ARG DB_GOV=openbank_govdb
ARG DB_IS_CONFIG=openbank_iskm_configdb
ARG DB_OPEN_BANKING_STORE=openbank_openbankingdb
ARG DB_OB_REPORTING=openbank_ob_reporting_statsdb
ARG DB_OB_REPORTING_SUMMARIZED=openbank_ob_reporting_summarizeddb

# change user to root for elevated permissions to override inherited non-root user
USER root

# add Open Banking artifacts to base product
RUN \
    wget -O ${WSO2_OB_ACCELERATOR}.zip "${WSO2_OB_Accelerator_DIST_URL}" \
    && unzip -d ${WSO2_SERVER_HOME}/ ${WSO2_OB_ACCELERATOR}.zip \
    && rm -f ${WSO2_OB_ACCELERATOR}.zip

# add keystores to base product 
RUN if [ -n "$WSO2_OB_KEYSTORES_URL" ]; then wget -O client-truststore.jks "${WSO2_OB_KEYSTORES_URL}/client-truststore.jks" \
    && cp client-truststore.jks ${WSO2_SERVER_HOME}/resources/security/ \
    && rm -f client-truststore.jks \
    && wget -O wso2carbon.jks "${WSO2_OB_KEYSTORES_URL}/wso2carbon.jks" \
    && cp wso2carbon.jks ${WSO2_SERVER_HOME}/resources/security/ \
    && rm -f wso2carbon.jks; fi 

# set configurations
# read deployment.yaml file
ARG DEPLOYMENT_YAML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.yaml
RUN \
    cp ${WSO2_OB_ACCELERATOR_DIR}/repository/resources/${WSO2_SERVER}-deployment.yaml ${DEPLOYMENT_YAML_FILE} \
# configure hostnames
    && sed -i -e 's|IS_HOSTNAME|'${IS_HOSTNAME}'|g' ${DEPLOYMENT_YAML_FILE} \
    && sed -i -e 's|APIM_HOSTNAME|'${APIM_HOSTNAME}'|g' ${DEPLOYMENT_YAML_FILE} \
    && sed -i -e 's|BI_HOSTNAME|'${BI_HOSTNAME}'|g' ${DEPLOYMENT_YAML_FILE} \
# configure datasource
    && sed -i -e 's|DB_OB_REPORTING_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_OB_REPORTING}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_YAML_FILE} \
    && sed -i -e 's|DB_OB_REPORTING_SUMMARIZED_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_OB_REPORTING_SUMMARIZED}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_YAML_FILE} \
    && sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_YAML_FILE} \
    && sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_YAML_FILE} \
    && sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_YAML_FILE} \
# copy deployment.yaml file to repository/conf
    && cp ${DEPLOYMENT_YAML_FILE} ${WSO2_SERVER_HOME}/conf/server \
    && rm ${DEPLOYMENT_YAML_FILE}

# copy the obbi accelerator artifacts on top of WSO2 Streaming Integrator base product
RUN cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/

# change directory rights
RUN \
    chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/ \
    && chown wso2carbon:wso2 /etc/motd

# set the non-root user
USER ${USER_ID}

# set MOTD login message for open banking
RUN echo "${MOTD}" > /etc/motd

# expose server ports
EXPOSE 9712 9612 7712 7612 9092 9444

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
