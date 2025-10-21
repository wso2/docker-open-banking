# Dockerfile for WSO2 Financial Services API Management Accelerator Module #
This section defines the step-by-step instructions to build an [Alpine](https://hub.docker.com/_/alpine/) Linux based Docker image for WSO2 Financial Services API Management Module.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v20.10.10 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client
* WSO2 Financial Services API Management Accelerator Module pack downloaded through [WSO2 Updates 2.0](https://ob.docs.wso2.com/en/latest/install-and-setup/setting-up-servers/)

## How to build an image

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-open-banking.git
```
> The local copy of the `dockerfiles/obam` directory will be referred to as `OBAM_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<OBAM_DOCKERFILE_HOME>` directory
- Execute `docker build` command as shown below.
    ```
  docker build --build-arg WSO2_OB_ACCELERATOR_DIST_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> -t wso2-obam:4.0.0 .
    ```
    
    * eg:- **Hosted locally**: `docker build --build-arg WSO2_OB_ACCELERATOR_DIST_URL=http://localhost:8000/wso2-fsam-accelerator-4.0.0.tar.gz -t wso2-obam:4.0.0 .` <br><br>
    * eg:- **Hosted remotely**: `docker build --build-arg --build-arg WSO2_OB_ACCELERATOR_DIST_URL=http://<public_ip:port>/wso2-fsam-accelerator-4.0.0.tar.gz -t wso2-obam:4.0.0 .`
  
## Using the Docker Image

The docker images for WSO2 Financial Services API Management Accelerator Module are not designed to run indivitually. Users have to use the Docker Image and build the container images for WSO2 API Manager with Financial Services API Management Accelerator Module.

Please refer to the sample docker file written in the `samples/wso2am_with_obam` directory.

```
## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
