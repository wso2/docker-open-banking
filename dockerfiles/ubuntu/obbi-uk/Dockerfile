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
ARG BASE_PRODUCT_VERSION
ARG ACCELERATOR_PRODUCT_VERSION=3.0.0.0-si${BASE_PRODUCT_VERSION}.0
# set base Docker image to WSO2 Open Banking Business Intelligence Ubuntu Docker image
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2-obbi:${ACCELERATOR_PRODUCT_VERSION}
LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v3.0.0.10"

# set Docker image build arguments
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME=wso2si
# declaring again BASE_PRODUCT_VERSION ARG to use in build stage
ARG BASE_PRODUCT_VERSION
ARG WSO2_OB_TOOLKIT_NAME=wso2-obbi-toolkit-uk
ARG WSO2_OB_TOOLKIT_VERSION=1.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${BASE_PRODUCT_VERSION}
ARG WSO2_OB_TOOLKIT=${WSO2_OB_TOOLKIT_NAME}-${WSO2_OB_TOOLKIT_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_TOOLKIT_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_TOOLKIT}
ARG WSO2_OB_TOOLKIT_DIST_URL
# build argument for MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of The WSO2 Open Banking Solution, with its latest GA release \n\
which is under The WSO2 Commercial License 1.0. \n\
Read more about The WSO2 Commercial License, Version 1.0 here @ http://wso2.com/licenses \n"

# configuration properties for deployment.toml file
# server hostnames
ARG IS_HOSTNAME=obiam
ARG APIM_HOSTNAME=obam
ARG BI_HOSTNAME=obbi
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

# install dependencies
RUN if [ "${BASE_PRODUCT_VERSION}" = "4.2.0" ]; then \
        apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends unzip wget \
        && rm -rf /var/lib/apt/lists/* ; \
    fi

# add Open Banking artifacts to base product
RUN \
    wget -O ${WSO2_OB_TOOLKIT}.zip "${WSO2_OB_TOOLKIT_DIST_URL}" \
    && unzip -d ${WSO2_SERVER_HOME}/ ${WSO2_OB_TOOLKIT}.zip \
    && rm -f ${WSO2_OB_TOOLKIT}.zip

# copy the WSO2 OB BI UK Toolkit artifacts on top of WSO2 OBBI accelarator image
# Remove default AuthenticationDataSubmissionApp.siddhi
RUN \
    rm ${WSO2_SERVER_HOME}/deployment/siddhi-files/AuthenticationDataSubmissionApp.siddhi \
# copy toolkit artifacts
    && cp -r ${WSO2_OB_TOOLKIT_DIR}/carbon-home/* "${WSO2_SERVER_HOME}"

# change directory rights
RUN \
    chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/ \
    && chown wso2carbon:wso2 /etc/motd

# remove unnecesary packages
RUN if [ "${BASE_PRODUCT_VERSION}" = "4.2.0" ]; then \
        apt-get purge -y unzip wget ;\
    fi

# set the non-root user
USER ${USER_ID}

# set MOTD login message for open banking
RUN echo "${MOTD}" > /etc/motd

# expose server ports
EXPOSE 9712 9612 7712 7612 9092 9444

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
