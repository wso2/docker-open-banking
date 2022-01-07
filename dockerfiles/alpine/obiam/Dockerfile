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

# set base Docker image to WSO2 Identity Server Alpine Docker image
FROM wso2/wso2is:5.11.0-alpine
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
ARG WSO2_SERVER_NAME=wso2is
ARG WSO2_SERVER_VERSION=5.11.0
ARG WSO2_OB_ACCELERATOR_NAME=wso2-obiam-accelerator
ARG WSO2_OB_ACCELERATOR_VERSION=3.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_OB_ACCELERATOR=${WSO2_OB_ACCELERATOR_NAME}-${WSO2_OB_ACCELERATOR_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_OB_ACCELERATOR_DIR=${WSO2_SERVER_HOME}/${WSO2_OB_ACCELERATOR}
# build argument for MOTD
ARG MOTD='printf "\n\
 Welcome to WSO2 Docker Resources \n\
 --------------------------------- \n\
 This Docker container comprises of The WSO2 Open Banking Solution, with its latest GA release \n\
 which is under The WSO2 Commercial License 1.0. \n\
 Read more about The WSO2 Commercial License, Version 1.0 here @ http://wso2.com/licenses \n"'
ENV ENV=${USER_HOME}"/.ashrc"

# create the non-root user and group and set MOTD login message
#RUN echo ${MOTD} > "${ENV}"

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

# copy Open Banking artifacts to base image
ADD --chown=wso2carbon:wso2 ${WSO2_OB_ACCELERATOR}.tar.gz ${WSO2_SERVER_HOME}/
ADD --chown=wso2carbon:wso2 ${WSO2_SERVER_NAME}-extensions-1.2.10.tar.gz ${USER_HOME}
COPY --chown=wso2carbon:wso2 cert ${USER_HOME}/cert
# change directory rights
RUN chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}/

# set configurations
# read deployment.toml file
ARG DEPLOYMENT_TOML_FILE=${WSO2_OB_ACCELERATOR_DIR}/repository/resources/deployment.toml
RUN cp ${WSO2_OB_ACCELERATOR_DIR}/repository/resources/wso2is-5.11.0-deployment.toml ${DEPLOYMENT_TOML_FILE}
# configure hostnames
RUN sed -i -e 's|IS_HOSTNAME|'${IS_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|APIM_HOSTNAME|'${APIM_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|BI_HOSTNAME|'${BI_HOSTNAME}'|g' ${DEPLOYMENT_TOML_FILE}
# configure datasources
RUN sed -i -e 's|DB_APIMGT_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_APIMGT}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_GOV_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_GOV}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_IS_CONFIG_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_IS_CONFIG}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_USER_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_USER_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_OB_STORE_URL|jdbc:mysql://'${DB_HOST}':3306/'${DB_OPEN_BANKING_STORE}'?autoReconnect=true\&amp;useSSL=false|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_USER|'${DB_USER}'|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_PASS|'${DB_PASS}'|g' ${DEPLOYMENT_TOML_FILE}
RUN sed -i -e 's|DB_DRIVER|'${DB_DRIVER}'|g' ${DEPLOYMENT_TOML_FILE}
# Copy deployment.toml file to repository/conf
RUN cp ${DEPLOYMENT_TOML_FILE} ${WSO2_SERVER_HOME}/repository/conf/
RUN rm ${DEPLOYMENT_TOML_FILE}

# copy the WSO2 OBIAM accelerator artifacts on top of WSO2 IS base product
# Remove old open banking artifacts from base product
RUN find ${WSO2_SERVER_HOME}/repository/components/dropins -name "com.wso2.openbanking.*" -exec rm -rf {} \;
RUN find ${WSO2_SERVER_HOME}/repository/components/lib -name "com.wso2.openbanking.*" -exec rm -rf {} \;
# Copying open banking artifacts
RUN cp -r ${WSO2_OB_ACCELERATOR_DIR}/carbon-home/* ${WSO2_SERVER_HOME}/
RUN rm ${WSO2_SERVER_HOME}/repository/components/dropins/org.wso2.carbon.identity.application.authentication.handler.identifier-6.3.11.jar
# 2. configure_iskm_connector
RUN cp ${USER_HOME}/wso2is-extensions-1.2.10/dropins/* ${WSO2_SERVER_HOME}/repository/components/dropins/
RUN cp ${USER_HOME}/wso2is-extensions-1.2.10/webapps/* ${WSO2_SERVER_HOME}/repository/deployment/server/webapps/

# add root and issuer certificates to client-truststore.jks
RUN yes | keytool -import -alias ob-root -file cert/root.cer -storetype JKS -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon
RUN yes | keytool -import -alias ob-issuer -file cert/iss.cer -storetype JKS -keystore ${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks  -storepass wso2carbon

# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# expose ports
EXPOSE 9446

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
