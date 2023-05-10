# ----------------------------------------------------------------------------------------
#
# Copyright (c) 2022-2023, WSO2 LLC. (https://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# ----------------------------------------------------------------------------------------

ARG BASE_DOCKER_IMAGE_REGISTRY="docker.wso2.com"
ARG BASE_PRODUCT_VERSION

# set base Docker image to WSO2 Identity Server Alpine Docker image
FROM ${BASE_DOCKER_IMAGE_REGISTRY}/wso2is:${BASE_PRODUCT_VERSION}.0-alpine
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
ARG WSO2_SERVER_NAME=wso2is
# declaring again BASE_PRODUCT_VERSION ARG to use in build stage
ARG BASE_PRODUCT_VERSION
ARG WSO2_OB_ACCELERATOR_NAME=wso2-obiam-accelerator
ARG WSO2_OB_ACCELERATOR_VERSION=3.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${BASE_PRODUCT_VERSION}
ARG WSO2_OB_ACCELERATOR=${WSO2_OB_ACCELERATOR_NAME}-${WSO2_OB_ACCELERATOR_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}
ARG WSO2_OB_ACCELERATOR_DIST_URL
ARG OB_TRUSTED_CERTS_URL
ARG WSO2_OB_KEYSTORES_URL
# build argument for MOTD
ARG MOTD='printf "\n\
 Welcome to WSO2 Docker Resources \n\
 --------------------------------- \n\
 This Docker container comprises of The WSO2 Open Banking Solution, with its latest GA release \n\
 which is under The WSO2 Commercial License 1.0. \n\
 Read more about The WSO2 Commercial License, Version 1.0 here @ http://wso2.com/licenses \n"'
ENV ENV=${USER_HOME}"/.ashrc"

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

# add Open Banking artifacts to base product
RUN \
    wget -O ${WSO2_OB_ACCELERATOR}.zip "${WSO2_OB_ACCELERATOR_DIST_URL}" \
    && unzip -d ${WSO2_SERVER_HOME}/ ${WSO2_OB_ACCELERATOR}.zip \
    && rm -f ${WSO2_OB_ACCELERATOR}.zip \
    && wget -O ob-cert.zip "${OB_TRUSTED_CERTS_URL}" \
    && unzip -d ${USER_HOME} ob-cert.zip  \
    && rm -f ob-cert.zip 

# add keystores to base product 
RUN if [ -n "$WSO2_OB_KEYSTORES_URL" ]; then wget -O private-keys.jks "${WSO2_OB_KEYSTORES_URL}/private-keys.jks"  \
    && yes | keytool -importkeystore -srckeystore ${USER_HOME}/private-keys.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks -srcalias wso2carbon-obiam -destalias wso2carbon -srcstorepass wso2carbon -deststorepass wso2carbon \
    && rm -f private-keys.jks\
    && wget -O public-certs.jks "${WSO2_OB_KEYSTORES_URL}/public-certs.jks" \
    && keytool -importkeystore -srckeystore ${USER_HOME}/public-certs.jks -destkeystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks -srcstorepass wso2carbon -deststorepass wso2carbon \
    && rm -r public-certs.jks ; fi 

# set configurations
# read deployment.toml file
ARG DEPLOYMENT_TOML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.toml
RUN \
    cp ${WSO2_OB_ACCELERATOR_DIR}/repository/resources/wso2is-5.11.0-deployment.toml ${DEPLOYMENT_TOML_FILE} \
# configure hostnames
    && sed -i -e 's|IS_HOSTNAME|'${IS_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|APIM_HOSTNAME|'${APIM_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|BI_HOSTNAME|'${BI_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
# configure datasources
    && sed -i -e 's|DB_APIMGT_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_APIMGT}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_GOV_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_GOV}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_IS_CONFIG_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_IS_CONFIG}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_USER_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_OB_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_OPEN_BANKING_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE} \
# copy deployment.toml file to original product pack location
    && cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/ \
    && rm ${DEPLOYMENT_TOML_FILE}

# copy the WSO2 OBIAM accelerator artifacts on top of WSO2 IS base product
# remove old open banking artifacts from base product
RUN \
    find ${WSO2_SERVER_HOME}/repository/components/dropins -name "com.wso2.openbanking.*" -exec rm -rf {} \; \
    && find ${WSO2_SERVER_HOME}/repository/components/lib -name "com.wso2.openbanking.*" -exec rm -rf {} \; \
# copy open banking artifacts
    && cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/ \
    && find ${WSO2_SERVER_HOME}/repository/components/dropins -name "org.wso2.carbon.identity.application.authentication.handler.identifier-*" -exec rm -rf {} \; 

# add root and issuer certificates to client-truststore.jks
RUN \
    yes | keytool -import -alias ob-root -file root.cer -storetype JKS -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon \
    && yes | keytool -import -alias ob-issuer -file iss.cer -storetype JKS -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon \
    && rm -f root.cer iss.cer

# change directory rights
RUN chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/

# set the non-root user
USER ${USER_ID}

# set MOTD login message for open banking
RUN echo ${MOTD} > "${ENV}"

# expose ports
EXPOSE 9446

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
