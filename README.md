# Docker and Docker Sample Resources for WSO2 Open Banking

This repository contains the following resources:

- WSO2 Open Banking API Manager Accelerator Module Dockerfile
- WSO2 Open Banking Identity & Access Management Accelerator Module Dockerfile
- Sample Dockerfiles to following.
  - Deploy WSO2 Open Banking API Manager Accelerator Module on top of WSO2 API Manager
  - Deploy WSO2 Open Banking Identity & Access Management Accelerator Module on top of WSO2 Identity Server
- Docker Compose resources to evaluate WSO2 Open Banking API Manager with WSO2 Open Banking Identity & Access Management Accelerator Module

Docker resources for WSO2 Open Banking API Manager and WSO2 Open Banking Identity & Access Management Module builds a docker image containing extracted Accelerator module.

Sample Dockerfile for WSO2 Open Banking API Manager and WSO2 Open Banking Identity & Access Management Module help you build generic Docker images for deploying the corresponding product servers in containerized environments. Each Docker image includes the JDK, the relevant product distribution and a collection of utility libraries. Configurations, custom JDBC
drivers, extensions and other deployable artifacts are designed to be provided via volume mounts to the containers spawned.

Docker Compose resources have been created according to the most common WSO2 Open Banking deployment profiles available for allowing users to quickly evaluate product features along side their co-operate Open Banking requirements. The Compose resources make use of Docker images built in the above step.
## Dockerfiles Structure

  Outer alpine & ubuntu directories contain the dockerfiles with default jdk versions. The default jdk version of an OB product is the same the base product default jdk version. The default jdk version is mentioned within the brackets below. For other jdk versions, seperate directoriers are maintained.

```bash
├── dockerfiles
│     │── obiam
│     └── obam
└── samples
      │── wso2is_with_obiam
      │── wso2am_with_obam
      │── keystores
      └── docker-compose
            └── wso2am-with-wso2is
```

## Contributions

For details on how to contribute to this repository, please refer [this](CONTRIBUTING.md) documentation.
