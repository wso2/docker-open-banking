# Changelog

All notable changes to Docker and Docker Compose resources for WSO2 Open Banking version `2.0.0` in each resource release, will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [v2.0.0.3] - 2021-08-05

### Added

- WSO2 Open Banking Business Intelligence support for Australian Specification (refer to [issue](https://github.com/wso2/docker-open-banking/issues/111))

## [v2.0.0.2] - 2021-01-13

### Fixed

- Fix product name change of Open Banking Identity & Access Management Module in OB 2.0 release (refer to [issue](https://github.com/wso2/docker-open-banking/issues/103))

## [v2.0.0.1] - 2021-01-06

### Added

- Open Banking UK and BERLIN specifications support	- Alpine and Ubuntu based Docker resources for WSO2 Open Banking API Manager `2.0.0`, WSO2 Open Banking Identity Server
  as Identity & Access Management Module version `2.0.0` and WSO2 Open Banking Business Intelligence Dashboard and Worker profiles `2.0.0`
- Upgrade profile based dockerfiles to use Adopt OpenJDK `jdk8u272-b10` as the base image
- Docker Compose resources for OBAM, OBIAM with OBBI deployment patterns based on UK and Berlin specifications
- Docker Compose resources for OBAM with OBIAM deployment patterns based on UK and AU specifications  
- Solution is based on WSO2 APIM 3.1.0 and WSO2 ISKM 5.10.0  
- Previous XML based configurations are carried out using TOML based configurations. Please refer the documentation for detailed mapping of configuration changes [Map Configurations](https://docs.wso2.com/display/OB200/Map+XML+Configurations+to+TOML+Configurations)
- For detailed information of the WSO2 Open Banking 2.0.0 product release, please see the GitHub release notes [Releases](https://github.com/wso2-enterprise/financial-open-banking/releases)

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v2.0.0.1](https://github.com/wso2/docker-open-banking/milestone/11)

[v2.0.0.3]: https://github.com/wso2/docker-open-banking/compare/v2.0.0.2...v2.0.0.3
[v2.0.0.2]: https://github.com/wso2/docker-open-banking/compare/v2.0.0.1...v2.0.0.2
[v2.0.0.1]: https://github.com/wso2/docker-open-banking/compare/v1.5.0.2...v2.0.0.1

