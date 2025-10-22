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

FROM alpine:3.22

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-open-banking/releases/tag/v4.0.0.1"

ARG USER=wso2carbon
ARG USER_HOME=/home/${USER}
ARG WSO2_FS_ACCELERATOR_NAME=wso2-fsiam-accelerator
ARG WSO2_FS_ACCELERATOR_VERSION=4.0.0
ARG WSO2_FS_ACCELERATOR=${WSO2_FS_ACCELERATOR_NAME}-${WSO2_FS_ACCELERATOR_VERSION}
ARG WSO2_SERVER_DIST_URL

# build argument for MOTD
ARG MOTD='printf "\n\
 Welcome to WSO2 Docker Resources \n\
 --------------------------------- \n\
 This Docker container comprises of The WSO2 Financial Services IAM Accelerator, with its latest GA release \n\
 which is under The WSO2 Commercial License 1.0. \n\
 Read more about The WSO2 Commercial License, Version 1.0 here @ http://wso2.com/licenses \n"'
ENV ENV=${USER_HOME}"/.ashrc"

# Create user and working directory
RUN adduser -D -h ${USER_HOME} ${USER}
USER ${USER}
WORKDIR ${USER_HOME}

# add Open Banking artifacts to base product
RUN \
    wget -O ${WSO2_FS_ACCELERATOR}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME}/ ${WSO2_FS_ACCELERATOR}.zip \
    && rm -f ${WSO2_FS_ACCELERATOR}.zip

# Default working directory
WORKDIR ${USER_HOME}/${WSO2_FS_ACCELERATOR}

# Default command (override in docker run if needed)
CMD ["bash"]
