# Docker and Docker Compose Resources for WSO2 Open Banking

This repository contains the following resources:

- WSO2 Open Banking API Manager Accelerator Module Dockerfile for Ubuntu and Alpine
- WSO2 Open Banking Identity & Access Management Accelerator Module Dockerfile for Ubuntu and Alpine
- Docker Compose resources to evaluate WSO2 Open Banking API Manager with WSO2 Open Banking Identity & Access Management Accelerator Module

Docker resources for WSO2 Open Banking API Manager and WSO2 Open Banking Identity & Access Management Module help you build generic Docker images for deploying the corresponding product servers in containerized environments. Each Docker image includes the JDK, the relevant product distribution and a collection of utility libraries. Configurations, custom JDBC
drivers, extensions and other deployable artifacts are designed to be provided via volume mounts to the containers spawned.

Docker Compose resources have been created according to the most common WSO2 Open Banking deployment profiles available for allowing users to quickly evaluate product features along side their co-operate Open Banking requirements. The Compose resources make use of Docker images of WSO2 Open Banking API Manager, WSO2 Open Banking Identity & Access Management Module and MySQL.

## Contributions

For details on how to contribute to this repository, please refer [this](CONTRIBUTING.md) documentation.
