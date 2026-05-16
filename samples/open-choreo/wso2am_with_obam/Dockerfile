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

# Define dynamic registry and version arguments globally
ARG BASE_DOCKER_IMAGE_REGISTRY="registry.wso2.com"
ARG BASE_PRODUCT_VERSION="4.5.0"

# ----------------------------------------------
# STAGE 1: ACCELERATOR SOURCE (obam)
# Uses a pre-built WSO2 Open Banking image that contains the extracted
# accelerator files.
# ----------------------------------------------
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2-ob/obam-accelerator:4.0.0.0-alpine AS obam

# Note: The test command verifies the expected accelerator directory exists
RUN test -d /home/wso2carbon/wso2-fsam-accelerator-4.0.0

# ----------------------------------------------
# STAGE 2: FINAL WSO2 AM IMAGE (Merge Accelerator)
# Sets up the base product and integrates the accelerator artifacts.
# ----------------------------------------------
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2-apim/am:${BASE_PRODUCT_VERSION}.0-alpine

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v4.0.0.3"

# --- Build Arguments (WSO2 Paths and Names) ---
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# declaring again BASE_PRODUCT_VERSION ARG to use in build stage
ARG BASE_PRODUCT_VERSION="4.5.0"
ARG WSO2_SERVER=wso2am-${BASE_PRODUCT_VERSION}
ARG WSO2_OB_ACCELERATOR=wso2-fsam-accelerator-4.0.0
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}

# --- Build Arguments (Configuration Overrides) ---
# server hostnames
ARG IS_HOSTNAME=obiam
ARG APIM_HOSTNAME=obam
# Admin Credentials
ARG AM_ADMIN_USERNAME=am_admin@wso2.com
ARG AM_ADMIN_PASSWORD=wso2123
ARG AM_ADMIN_NAME=am_admin
ARG IS_ADMIN_USERNAME=is_admin@wso2.com
ARG IS_ADMIN_PASSWORD=wso2123
# databases related properties
ARG DB_TYPE=mysql
ARG DB_USER=root
ARG DB_PASS=root
ARG DB_HOST=mysql
ARG DB_DRIVER=com.mysql.cj.jdbc.Driver
ARG DB_APIMGT=fs_apimgtdb
ARG DB_USER_STORE=fs_am_userdb
ARG DB_AM_CONFIG=fs_am_configdb

# --- Setup and Dependencies ---

# Ensure we are root to install tools and manage permissions if needed
USER root

# Install bash, wget and coreutils
RUN apk update && apk add bash wget coreutils openssl --no-cache

# --- Copy Accelerator ---

# Copy the extracted accelerator folder from the 'obam' stage into the WSO2 APIM home directory
COPY --from=obam ${USER_HOME}/${WSO2_OB_ACCELERATOR} ${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}

# --- Keystores and Truststores ---

# Copy keystores from local directory and import into product keystores
COPY keystores/private-keys.jks ${USER_HOME}/private-keys.jks
COPY keystores/public-certs.jks ${USER_HOME}/public-certs.jks

RUN yes | keytool -importkeystore \
        -srckeystore ${USER_HOME}/private-keys.jks \
        -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks \
        -srcalias wso2carbon-obam \
        -destalias wso2carbon \
        -srcstorepass wso2carbon \
        -deststorepass wso2carbon \
    && rm -f ${USER_HOME}/private-keys.jks \
    && keytool -importkeystore \
        -srckeystore ${USER_HOME}/public-certs.jks \
        -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks \
        -srcstorepass wso2carbon \
        -deststorepass wso2carbon \
    && rm -f ${USER_HOME}/public-certs.jks

# --- MySQL Connector ---

# Download MySQL connector 8.0.33 from Maven Central (supports caching_sha2_password)
RUN wget -O /tmp/mysql-connector-j-8.0.33.jar \
        "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar" \
    && cp /tmp/mysql-connector-j-8.0.33.jar ${WSO2_SERVER_HOME}/repository/components/lib/ \
    && rm -f /tmp/mysql-connector-j-8.0.33.jar

# --- Configuration using deployment.toml ---

ARG DEPLOYMENT_TOML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.toml
RUN \
    cp ${WSO2_OB_ACCELERATOR_DIR}/repository/resources/${WSO2_SERVER}-deployment.toml ${DEPLOYMENT_TOML_FILE} && \
    # configure hostnames
    sed -i -e 's|IS_HOSTNAME|'${IS_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|APIM_HOSTNAME|'${APIM_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} && \
    # configure Admin Credentials
    sed -i -e 's|AM_ADMIN_USERNAME|'${AM_ADMIN_USERNAME}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|AM_ADMIN_PASSWORD|'${AM_ADMIN_PASSWORD}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|IS_ADMIN_USERNAME|'${IS_ADMIN_USERNAME}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|IS_ADMIN_PASSWORD|'${IS_ADMIN_PASSWORD}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|AM_ADMIN_NAME|'${AM_ADMIN_NAME}'|g' ${DEPLOYMENT_TOML_FILE} && \
    # configure datasources with MySQL 8 compatible JDBC URL params
    sed -i -e 's|DB_APIMGT_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_APIMGT}'?autoReconnect=true\&amp;useSSL=false\&amp;allowPublicKeyRetrieval=true|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_AM_CONFIG_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_AM_CONFIG}'?autoReconnect=true\&amp;useSSL=false\&amp;allowPublicKeyRetrieval=true|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_USER_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_USER_STORE}'?autoReconnect=true\&amp;useSSL=false\&amp;allowPublicKeyRetrieval=true|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE}

RUN \
    cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/ && \
    rm ${DEPLOYMENT_TOML_FILE}

# --- Merge and Cleanup ---

# Remove old open banking artifacts from base product
RUN set -ex; \
    find ${WSO2_SERVER_HOME}/repository/components/dropins -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \; && \
    find ${WSO2_SERVER_HOME}/repository/components/lib -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \;

# Copy open banking accelerator artifacts on top of WSO2 APIM base product
RUN cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/

ARG SEQUENCE_FILE=${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs/default/sequences/_cors_request_handler_.xml
RUN \
    sed -i -e 's|</sequence>|<sequence key="customErrorFormatter"/></sequence>|g' ${SEQUENCE_FILE}

# --- Trusted Certificates ---

# Copy trusted certificates from local ob-certs directory and import into client-truststore
COPY ob-certs/root.cer ${USER_HOME}/root.cer
COPY ob-certs/issuer.cer ${USER_HOME}/issuer.cer

RUN \
    yes | keytool -import -alias fs-root \
        -file ${USER_HOME}/root.cer \
        -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks \
        -storepass wso2carbon \
    && yes | keytool -import -alias fs-issuer \
        -file ${USER_HOME}/issuer.cer \
        -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks \
        -storepass wso2carbon \
    && rm -f ${USER_HOME}/root.cer ${USER_HOME}/issuer.cer

# --- Permissions ---

RUN \
    chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/ \
    && chown wso2carbon:wso2 /etc/motd

# set the non-root user
USER ${USER}

# expose ports
EXPOSE 9443 8280 8243

# Ensure the entrypoint script is available in the WSO2 base image
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
