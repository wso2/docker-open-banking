# Changelog

All notable changes to Docker and Docker Compose resources for WSO2 Open Banking version `3.0.0` in each resource release, will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [v3.0.0.1] - 2022-01-20

### Added

- Alpine and Ubuntu based Docker resources for WSO2 Open Banking API Manager Accelerator Module version `3.0.0` and WSO2 Open Banking Identity & Access Management Accelerator Module version `3.0.0` (refer to [issue](https://github.com/wso2/docker-open-banking/issues/122))
- Docker Compose resources for OBAM with OBIAM Accelerator for OB 3.0.0 (refer to [issue](https://github.com/wso2/docker-open-banking/issues/123))
- Solution is based on WSO2 APIM 4.0.0 and WSO2 IS 5.11.0  
- Upgrade profile based dockerfiles to use docker.wso2.com/wso2is:5.11.0.0 and docker.wso2.com/wso2is:5.11.0.0 as the base images for OBAM and OBIAM respectively.
- Previous XML based configurations are carried out using TOML based configurations. Please refer the documentations for detailed mapping of configuration changes 
  - [Configuring Identity Server](https://ob.docs.wso2.com/en/latest/install-and-setup/configuring-identity-server-for-ob/)
  - [Configuring API Manager](https://ob.docs.wso2.com/en/latest/install-and-setup/configuring-api-manager-for-ob/)
- For detailed information of the WSO2 Open Banking 3.0.0 product release, please see the GitHub release notes [Releases](https://github.com/wso2-enterprise/financial-open-banking/releases)



