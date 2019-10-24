# Changelog
All notable changes to this project 1.4.x per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v1.4.0.4] - 2019-10-24

### Added
- Backward support for changing uk and berlin specs
- Readme instructions on creating a keystore
- openbank_geolocationdb mysql scripts

### Changed
- Incorrect mount path of registryDB
- MySQL url of WSO2AM_STATS_DB

For detailed information on the tasks carried out during this release, please see the GitHub milestone [v1.4.0.4](https://github.com/wso2/docker-open-banking/milestone/5).

## [v1.4.0.3] - 2019-10-11

### Added
- Docker Compose resources for Open Banking UK and Berlin specifications for Open Banking API Manager with Open Banking Key Manager profile
- Docker Compose resources for Open Banking UK and Berlin specifications for Open Banking API Manager and Open Banking Key Manager with Open Banking Business profiles

### Changed
- Separated DB scripts into different directories based on the specification
- Set ulimits and max_connections of MySQL containers

## [v1.4.0.2] - 2019-09-26

### Added
- Docker Compose resources for Open Banking UK specification for Open Banking API Manager with Open Banking Key Manager profile
- WSO2 Open Banking Business Intelligence v1.4.x Dockerfile for Ubuntu and Alpine

## [v1.4.0.1] - 2019-09-06

### Added
- WSO2 Open Banking API Manager v1.4.x Dockerfile for Ubuntu and Alpine
- WSO2 Open Banking Key Manager v1.4.x Dockerfile for Ubuntu and Alpine
