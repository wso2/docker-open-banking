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
ARG BASE_DOCKER_IMAGE_REGISTRY="docker.wso2.com"
ARG BASE_PRODUCT_VERSION

# ----------------------------------------------
# STAGE 1: ACCELERATOR SOURCE (obam)
# Uses a pre-built WSO2 Open Banking image that contains the extracted
# accelerator files.
# ----------------------------------------------
# NOTE: The base WSO2 images usually include the full product version (e.g., 4.0.0.0 or 4.0.0)
FROM wso2-obam:4.0.0 AS obam

# Note: The test command verifies the expected accelerator directory exists
RUN test -d /home/wso2carbon/wso2-fsam-accelerator-4.0.0

# ----------------------------------------------
# STAGE 2: FINAL WSO2 AM IMAGE (Merge Accelerator)
# Sets up the base product and integrates the accelerator artifacts.
# ----------------------------------------------
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2am:${BASE_PRODUCT_VERSION}.0-alpine

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v4.0.0.1"

# --- Build Arguments (WSO2 Paths and Names) ---
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# declaring again BASE_PRODUCT_VERSION ARG to use in build stage
ARG BASE_PRODUCT_VERSION
ARG WSO2_SERVER=wso2am-${BASE_PRODUCT_VERSION}
ARG WSO2_OB_ACCELERATOR=wso2-fsam-accelerator-4.0.0
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}

# --- Build Arguments (External Resources) ---
ARG OB_TRUSTED_CERTS_URL
ARG WSO2_OB_KEYSTORES_URL
ARG RESOURCE_URL

#ENV ENV=${USER_HOME}"/.ashrc"

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
ARG DB_DRIVER=com.mysql.jdbc.Driver
ARG DB_APIMGT=fs_apimgtdb
ARG DB_USER_STORE=fs_am_userdb
ARG DB_AM_CONFIG=fs_am_configdb

# --- Setup and Dependencies ---

# Ensure we are root to install tools and manage permissions if needed
USER root

# Install bash temporarily for running the merge script and keytool commands cleanly
# Also install coreutils for 'yes' command compatibility
RUN apk update && apk add bash coreutils openssl --no-cache

# --- Copy Accelerator ---

# Copy the extracted accelerator folder from the 'obam' stage into the WSO2 APIM home directory
COPY --from=obam ${USER_HOME}/${WSO2_OB_ACCELERATOR} ${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}

# --- Keystores, Truststores, and JDBC Driver Setup (Needs bash shell) ---

# add keystores to base product
RUN if [ -n "$WSO2_OB_KEYSTORES_URL" ]; then \
    wget -O ${USER_HOME}/private-keys.jks "${WSO2_OB_KEYSTORES_URL}/private-keys.jks" && \
    yes | keytool -importkeystore -srckeystore ${USER_HOME}/private-keys.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -srcalias wso2carbon-obam -destalias wso2carbon -srcstorepass wso2carbon -deststorepass wso2carbon && \
    rm -f ${USER_HOME}/private-keys.jks && \
    wget -O ${USER_HOME}/public-certs.jks "${WSO2_OB_KEYSTORES_URL}/public-certs.jks" && \
    yes | keytool -importkeystore -srckeystore ${USER_HOME}/public-certs.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks -srcstorepass wso2carbon -deststorepass wso2carbon && \
    rm -f ${USER_HOME}/public-certs.jks ; fi

# Adding database connector
RUN if [ -n "$RESOURCE_URL" ]; then \
    wget -O ${USER_HOME}/mysql-connector-java-5.1.44.jar "${RESOURCE_URL}/mysql-connector-java-5.1.44.jar" && \
    cp ${USER_HOME}/mysql-connector-java-5.1.44.jar ${WSO2_SERVER_HOME}/repository/components/lib && \
    rm -f ${USER_HOME}/mysql-connector-java-5.1.44.jar ; fi

# Adding custom error sequence
RUN if [ -n "RESOURCE_URL" ]; then wget -O customErrorFormatter.xml "${RESOURCE_URL}/customErrorFormatter.xml"  \
    && cp customErrorFormatter.xml ${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs/default/sequences \
    && rm -f customErrorFormatter.xml ; fi

# --- Configuration using deployment.toml ---

# set configurations
ARG DEPLOYMENT_TOML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.toml
RUN \
    # Create the final TOML file inside the accelerator directory
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
    # configure datasources
    sed -i -e 's|DB_APIMGT_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_APIMGT}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_AM_CONFIG_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_AM_CONFIG}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_USER_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_USER_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE} && \
    sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE}

RUN grep -q 'skip_list.sequences' ${DEPLOYMENT_TOML_FILE} || \
    sed -i '/^gateway_labels =\["Default"\]/a skip_list.sequences = ["customErrorFormatter.xml"]' ${DEPLOYMENT_TOML_FILE}

RUN \
    # copy deployment.toml file to repository/conf
    cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/ && \
    rm ${DEPLOYMENT_TOML_FILE}

# --- Merge and Cleanup ---

# copy the WSO2 OB APIM accelerator artifacts on top of WSO2 APIM base product
# remove old open banking artifacts from base product (using bash's 'find' for better compatibility)
RUN set -ex; \
    find ${WSO2_SERVER_HOME}/repository/components/dropins -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \; && \
    find ${WSO2_SERVER_HOME}/repository/components/lib -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \;

# copy open banking artifacts using cp -r (this is effectively the 'merge' operation)
RUN cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/

ARG SEQUENCE_FILE=${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs/default/sequences/_cors_request_handler_.xml
RUN \
  sed -i -e 's|</sequence>|<sequence key="customErrorFormatter"/></sequence>|g' ${SEQUENCE_FILE}

# add root and issuer certificates to client-truststore.jks
RUN \
    wget -O ${USER_HOME}/fs-cert.zip "${OB_TRUSTED_CERTS_URL}" && \
    unzip -d ${USER_HOME} ${USER_HOME}/fs-cert.zip && \
    rm -f ${USER_HOME}/fs-cert.zip

RUN \
    yes | keytool -import -alias fs-root -file ${USER_HOME}/root.cer -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon && \
    yes | keytool -import -alias fs-issuer -file ${USER_HOME}/issuer.cer -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon && \
    rm -f ${USER_HOME}/root.cer ${USER_HOME}/issuer.cer

# change directory rights
# change directory rights
RUN \
    chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/ \
    && chown wso2carbon:wso2 /etc/motd

# set the non-root user
USER ${USER}

# expose ports
EXPOSE 9443 8280 8243

RUN test -d /home/wso2carbon/wso2am-4.5.0
# Ensure the entrypoint script is available in the WSO2 base image
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
