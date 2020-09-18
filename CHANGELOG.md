# Changelog

All notable changes to Docker and Docker Compose resources for WSO2 Open Banking version `1.5.x` in each resource release, will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [v1.5.0.2] - 2020-09-18

### Environments

- Successful evaluation using Docker Engine Community version `19.03.5` (both client and server)

### Added

- Add the Docker source Git release tag version to image metadata (refer to [issue](https://github.com/wso2/docker-open-banking/issues/85))
- Add support for data persistence during Apache based Solr Indexing (refer to [issue](https://github.com/wso2/docker-open-banking/issues/81))
- Enable SSL Verification for Wget (refer to [issue](https://github.com/wso2/docker-open-banking/issues/84))

### Changed

- Package the latest version of WSO2 Kubernetes membership scheme - `v1.0.7` (refer to [issue](https://github.com/wso2/docker-open-banking/issues/77))

### Fixed

- Fix incorrect port definition of Key Manager product profile (refer to [issue](https://github.com/wso2/docker-open-banking/issues/79))
- Fix incorrect port definition of Business Intelligence product profiles (refer to [issue](https://github.com/wso2/docker-open-banking/issues/83))

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v1.5.0.2](https://github.com/wso2/docker-open-banking/milestone/10).

## [v1.5.0.1] - 2020-05-22

### Added

- Open Banking AU specification support	- Alpine and Ubuntu based Docker resources for WSO2 Open Banking API Manager `1.5.0`, WSO2 Open Banking Identity Server 
as Key Manager version `1.5.0` and WSO2 Open Banking Business Intelligence Dashboard and Worker profiles `1.5.0`
- Upgrade the profiles to use MySQL `5.7.24`
- Upgrade profiles to use Adopt OpenJDK `jdk8u242-b08`
- Docker Compose resources for OBAM with OBKM and  OBAM, OBKM with OBBI deployment patterns

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.5.0.1](https://github.com/wso2/docker-open-banking/milestone/8)

[v1.5.0.2]: https://github.com/wso2/docker-open-banking/compare/v1.5.0.1...v1.5.0.2
[v1.5.0.1]: https://github.com/wso2/docker-open-banking/compare/v1.4.0.6...v1.5.0.1
