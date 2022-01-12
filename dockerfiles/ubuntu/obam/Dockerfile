# ------------------------------------------------------------------------
#
# Copyright 2022 WSO2, Inc. (http://wso2.com)
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
#
# ------------------------------------------------------------------------

# set base Docker image to WSO2 API Manager Ubuntu Docker image
FROM docker.wso2.com/wso2am:4.0.0.0
LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v3.0.0.1"

# set Docker image build arguments
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME=wso2am
ARG WSO2_SERVER_VERSION=4.0.0
ARG WSO2_OB_ACCELERATOR_NAME=wso2-obam-accelerator
ARG WSO2_OB_ACCELERATOR_VERSION=3.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_OB_ACCELERATOR=${WSO2_OB_ACCELERATOR_NAME}-${WSO2_OB_ACCELERATOR_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}
ARG WSO2_OB_Accelerator_DIST_URL
ARG WSO2_OB_CERTS_URL
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
ARG DB_PASS=9900
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
    wget -O ${WSO2_OB_ACCELERATOR}.tar.gz "${WSO2_OB_Accelerator_DIST_URL}" \
    && tar -xzf ${WSO2_OB_ACCELERATOR}.tar.gz --directory ${WSO2_SERVER_HOME}/ \
    && rm -f ${WSO2_OB_ACCELERATOR}.tar.gz \
    && wget -O ob-cert.zip "${WSO2_OB_CERTS_URL}" \
    && unzip -d ${USER_HOME} ob-cert.zip  \
    && rm -f ob-cert.zip

# set configurations
# read deployment.toml file
ARG DEPLOYMENT_TOML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.toml
RUN \
    cp ${WSO2_OB_ACCELERATOR_DIR}/repository/resources/${WSO2_SERVER}-deployment.toml ${DEPLOYMENT_TOML_FILE} \
# configure hostnames
    && sed -i -e 's|IS_HOSTNAME|'${IS_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|APIM_HOSTNAME|'${APIM_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|BI_HOSTNAME|'${BI_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE} \
# configure datasources
    && sed -i -e 's|DB_APIMGT_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_APIMGT}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_AM_CONFIG_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_AM_CONFIG}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_GOV_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_GOV}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_USER_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE} \
    && sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE} \
# copy deployment.toml file to repository/conf
    && cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/ \
    && rm ${DEPLOYMENT_TOML_FILE} \
# add json converter for fault sequences
    && sed -i -e 's|</sequence>|\t<sequence key="jsonConverter"/>\n</sequence>|g' ${WSO2_SERVER_HOME}/repository/deployment/server/synapse-configs/default/sequences/_cors_request_handler_.xml

# copy the WSO2 OB APIM accelerator artifacts on top of WSO2 APIM base product
# Remove old open banking artifacts from base product
RUN \
    find ${WSO2_SERVER_HOME}/repository/components/dropins -name "com.wso2.openbanking.*" -exec rm -rf {} \; \
    && find ${WSO2_SERVER_HOME}/repository/components/lib -name "com.wso2.openbanking.*" -exec rm -rf {} \; \
# Copying open banking artifacts
    && cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/

# add root and issuer certificates to client-truststore.jks
RUN \
    yes | keytool -import -alias ob-root -file root.cer -storetype JKS -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon \
    && yes | keytool -import -alias ob-issuer -file iss.cer -storetype JKS -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon \
    && rm -f root.cer iss.cer

# change directory rights
RUN \
    chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/ \
    && chown wso2carbon:wso2 /etc/motd

# set the non-root user
USER ${USER_ID}

# set MOTD login message for open banking
RUN echo "${MOTD}" > /etc/motd

# expose ports
EXPOSE 9443 8280 8243

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
