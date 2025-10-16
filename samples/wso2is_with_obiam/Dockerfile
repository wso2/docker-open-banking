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
# STAGE 1: ACCELERATOR SOURCE (obiam)
# Uses a pre-built WSO2 Open Banking image that contains the extracted
# accelerator files. This is faster and more reliable than downloading.
# ----------------------------------------------
FROM wso2-obiam:4.0.0 AS obiam

# Note: The test command verifies the expected accelerator directory exists
# This assumes the pre-built image structure is standardized.
RUN test -d /home/wso2carbon/wso2-fsiam-accelerator-4.0.0

# ----------------------------------------------
# STAGE 2: FINAL WSO2 IS IMAGE (Merge Accelerator)
# Sets up the base product and integrates the accelerator artifacts.
# ----------------------------------------------
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2is:${BASE_PRODUCT_VERSION}-alpine
LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v4.0.0.1"

# --- Build Arguments (Shared across WSO2 images) ---
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG BASE_PRODUCT_VERSION
ARG WSO2_SERVER=wso2is-${BASE_PRODUCT_VERSION}
ARG WSO2_OB_ACCELERATOR=wso2-fsiam-accelerator-4.0.0
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}

ARG OB_TRUSTED_CERTS_URL
ARG WSO2_OB_KEYSTORES_URL
ARG RESOURCE_URL

# configuration properties for deployment.toml file (kept for context)
# server hostnames
ARG IS_HOSTNAME=obiam
ARG APIM_HOSTNAME=obam
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
ARG DB_OB_STORE=fs_consentdb

# Ensure we are root to install tools and manage permissions if needed
USER root

# Install bash temporarily since the WSO2 IS Alpine base image might use ash, but the merge script expects bash syntax
RUN apk update && apk add bash --no-cache

# --- Copy and Install Accelerator ---

# Copy the extracted accelerator folder from the 'obiam' stage into the WSO2 IS home directory
# Source: /home/wso2carbon/wso2-fsiam-accelerator-4.0.0 from the obiam image
# Destination: /home/wso2carbon/wso2is-7.1.0/wso2-fsiam-accelerator-4.0.0 in the final image
COPY --from=obiam ${USER_HOME}/${WSO2_OB_ACCELERATOR} ${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}

# add keystores to base product 
RUN if [ -n "$WSO2_OB_KEYSTORES_URL" ]; then wget -O private-keys.jks "${WSO2_OB_KEYSTORES_URL}/private-keys.jks"  \
    && yes | keytool -importkeystore -srckeystore ${USER_HOME}/private-keys.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.p12 -srcalias wso2carbon-obiam -destalias wso2carbon -srcstorepass wso2carbon -deststorepass wso2carbon \
    && rm -f private-keys.jks\
    && wget -O public-certs.jks "${WSO2_OB_KEYSTORES_URL}/public-certs.jks" \
    && keytool -importkeystore -srckeystore ${USER_HOME}/public-certs.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.p12 -srcstorepass wso2carbon -deststorepass wso2carbon \
    && rm -r public-certs.jks ; fi

# Adding database connector
RUN if [ -n "RESOURCE_URL" ]; then wget -O mysql-connector-java-5.1.44.jar "${RESOURCE_URL}/mysql-connector-java-5.1.44.jar"  \
    && cp mysql-connector-java-5.1.44.jar ${WSO2_SERVER_HOME}/repository/components/lib \
    && rm -f mysql-connector-java-5.1.44.jar ; fi

# set configurations
# read deployment.toml file
ARG DEPLOYMENT_TOML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.toml

RUN \
    cd ${WSO2_OB_ACCELERATOR_DIR} \
    && cp ${WSO2_OB_ACCELERATOR_DIR}/repository/resources/${WSO2_SERVER}-deployment.toml ${DEPLOYMENT_TOML_FILE} \
 \
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
    && sed -i -e 's|DB_FS_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_OB_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|signature.alias="wso2carbon"|signature.alias="wso2obam"|g' ${DEPLOYMENT_TOML_FILE} \
# copy deployment.toml file to original product pack location
    && cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/ \
    && rm ${DEPLOYMENT_TOML_FILE}

# copy the WSO2 FSIAM accelerator artifacts on top of WSO2 IS base product
# remove old open banking artifacts from base product
RUN \
    find ${WSO2_SERVER_HOME}/repository/components/dropins -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \; \
    && find ${WSO2_SERVER_HOME}/repository/components/lib -name "org.wso2.financial.services.accelerator.*" -exec rm -rf {} \;

RUN \
    cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/

# add root and issuer certificates to client-truststore.jks
RUN \
    wget -O fs-cert.zip "${OB_TRUSTED_CERTS_URL}" \
    && unzip -d ${USER_HOME} fs-cert.zip  \
    && rm -f fs-cert.zip \

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

# expose ports
EXPOSE 9446

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
