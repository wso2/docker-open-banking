# ----------------------------------------------------------------------------------------
#
# Copyright (c) 2025, WSO2 LLC. (https://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# ----------------------------------------------------------------------------------------

ARG BASE_DOCKER_IMAGE_REGISTRY="docker.wso2.com"
ARG BASE_PRODUCT_VERSION  

# set base Docker image to WSO2 Identity Server Ubuntu Docker image
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2is:${BASE_PRODUCT_VERSION}.0-jdk17
LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v4.0.0.1"

# set Docker image build arguments
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802 
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME=wso2is
# declaring again BASE_PRODUCT_VERSION ARG to use in build stage
ARG BASE_PRODUCT_VERSION
ARG WSO2_FS_ACCELERATOR_NAME=wso2-fsiam-accelerator
ARG WSO2_FS_ACCELERATOR_VERSION=4.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${BASE_PRODUCT_VERSION}
ARG WSO2_FS_ACCELERATOR=${WSO2_FS_ACCELERATOR_NAME}-${WSO2_FS_ACCELERATOR_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_FS_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_FS_ACCELERATOR}
ARG WSO2_FS_ACCELERATOR_DIST_URL
ARG FS_TRUSTED_CERTS_URL
ARG WSO2_FS_KEYSTORES_URL
# build argument for MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of The WSO2 Financial Services Solution, with its latest GA release \n\
which is under The WSO2 Commercial License 1.0. \n\
Read more about The WSO2 Commercial License, Version 1.0 here @ http://wso2.com/licenses \n"

# configuration properties for deployment.toml file
# server hostnames
ARG IS_HOSTNAME=fsiam
ARG APIM_HOSTNAME=fsam
# Admin Credentials
ARG IS_ADMIN_USERNAME=is_admin@wso2.com
ARG IS_ADMIN_PASSWORD=wso2123
# databases related properties
ARG DB_TYPE=mysql
ARG DB_USER=root
ARG DB_PASS=root
ARG DB_HOST=mysql
ARG DB_DRIVER=com.mysql.jdbc.Driver
ARG DB_IDENTITY=fs_identitydb
ARG DB_USER_STORE=fs_userdb
ARG DB_IS_CONFIG=fs_iskm_configdb
ARG DB_FS_STORE=fs_consentdb

# change user to root for elevated permissions to override inherited non-root user
USER root

# add Open Banking artifacts to base product
RUN \
    wget -O ${WSO2_FS_ACCELERATOR}.zip "${WSO2_FS_ACCELERATOR_DIST_URL}" \
    && unzip -d ${WSO2_SERVER_HOME}/ ${WSO2_FS_ACCELERATOR}.zip \
    && rm -f ${WSO2_FS_ACCELERATOR}.zip \
    && wget -O fs-cert.zip "${FS_TRUSTED_CERTS_URL}" \
    && unzip -d ${USER_HOME} fs-cert.zip  \
    && rm -f fs-cert.zip

# add keystores to base product
RUN if [ -n "$WSO2_FS_KEYSTORES_URL" ]; then wget -O private-keys.jks "${WSO2_FS_KEYSTORES_URL}/private-keys.jks"  \
    && yes | keytool -importkeystore -srckeystore ${USER_HOME}/private-keys.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.p12 -srcalias wso2carbon-fsiam -destalias wso2carbon -srcstorepass wso2carbon -deststorepass wso2carbon \
    && rm -f private-keys.jks\
    && wget -O public-certs.jks "${WSO2_FS_KEYSTORES_URL}/public-certs.jks" \
    && keytool -importkeystore -srckeystore ${USER_HOME}/public-certs.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.p12 -srcstorepass wso2carbon -deststorepass wso2carbon \
    && rm -r public-certs.jks ; fi

# set configurations
# read deployment.toml file
ARG DEPLOYMENT_TOML_FILE=${WSO2_FS_ACCELERATOR_DIR}/repository/resources/deployment.toml
RUN \
    cp ${WSO2_FS_ACCELERATOR_DIR}/repository/resources/${WSO2_SERVER}-deployment.toml ${DEPLOYMENT_TOML_FILE} \
# configure hostnames
    && sed -i -e 's|IS_HOSTNAME|'${IS_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|APIM_HOSTNAME|'${APIM_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
# configure Admin Credentials
    && sed -i -e 's|IS_ADMIN_USERNAME|'${IS_ADMIN_USERNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|IS_ADMIN_PASSWORD|'${IS_ADMIN_PASSWORD}'|g' ${DEPLOYMENT_TOML_FILE} \
# configure datasources
    && sed -i -e 's|DB_IDENTITY_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_IDENTITY}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_IS_CONFIG_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_IS_CONFIG}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_GOV_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_IS_CONFIG}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_USER_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_FS_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_FS_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE} \
# copy deployment.toml file to original product pack location
    && cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/ \
    && rm ${DEPLOYMENT_TOML_FILE}

# copy the WSO2 FSIAM accelerator artifacts on top of WSO2 IS base product
# remove old open banking artifacts from base product
RUN \
    find ${WSO2_SERVER_HOME}/repository/components/dropins -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \; \
    && find ${WSO2_SERVER_HOME}/repository/components/lib -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \;

RUN \
    cp -r ${WSO2_FS_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/

RUN \
    yes | keytool -import -alias fs-root -file root.cer -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.p12  -storepass wso2carbon \
    && yes | keytool -import -alias fs-issuer -file issuer.cer -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.p12  -storepass wso2carbon \
    && rm -f root.cer issuer.cer

# change directory rights
RUN \
    chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/ \
    && chown wso2carbon:wso2 /etc/motd

# set the non-root user
USER ${USER_ID}

# set MOTD login message for open banking
RUN echo "${MOTD}" > /etc/motd

# expose ports
EXPOSE 9446

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
