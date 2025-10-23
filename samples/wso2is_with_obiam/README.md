# Dockerfile for deploying WSO2 Financial Services Identity Access Management Accelerator Module on top of WSO2 Identity Server
This section defines the step-by-step instructions to build an [Alpine](https://hub.docker.com/_/alpine/) Linux based Docker image for deploying WSO2 Financial Services Identity Access Management Accelerator Module on top of WSO2 Identity Server.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v20.10.10 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client
* Zip archive file of the Open Banking root and issuer certificates. 
  - Download the root and issuer [certificates](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/252018873/OB+Root+and+Issuing+Certificates+for+Sandbox).
  -  Rename the `OB_SandBox_PP_Root.cer` as `root.cer`.
  - Rename the `OB_SandBox_PP_Issuing.cer` as `issuer.cer`.
  - Zip the root.cer and issuer.cer in one zip archive file.
* Keystores directory of wso2 server certs of WSO2 Open Banking Docker Images. (https://github.com/wso2/docker-open-banking/raw/v4.0.0.3/samples/keystores)
* DB driver file matching to the DB type and version you are going to use with WSO2 API Manager.
* Host the downloaded artifacts locally or on a remote location.
  - The hosted locations of artifacts will be passed as the build arguments when building the Docker image.<br>
    1. **OB_TRUSTED_CERTS_URL** - Zip archive location of the certificates of WSO2 Open Banking root and issuer
    2. **WSO2_OB_KEYSTORES_URL** - Location of keystores folder of wso2 server certs
    3. **RESOURCE_URL** - Location of the DB driver file
  
## How to build an image

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-open-banking.git
```
> The local copy of the `samples/wso2is_with_obiam` directory will be referred to as `IAM_DOCKERFILE_HOME` from this point onwards.

##### 2. Update the Dockerfile with Database details.

- Setup Databases for WSO2 API Manager and WSO2 Open Banking Identity Server.
  - Follow the instructions provided in [Setting up Databases](https://ob.docs.wso2.com/en/latest/install-and-setup/setting-up-databases/) to setup the databases.
- Open the Dockerfile inside `<AM_DOCKERFILE_HOME>` and update database details.

##### 3. Build the Docker image.

- Navigate to `<IAM_DOCKERFILE_HOME>` directory
- Execute `docker build` command as shown below.
    ```
    docker build --build-arg BASE_PRODUCT_VERSION=<IS_VERSION> --build-arg OB_TRUSTED_CERTS_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> --build-arg WSO2_OB_KEYSTORES_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> --build-arg RESOURCE_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> -t wso2is-ob:4.0.0 .
    ```
    
    * eg:- **Hosted locally**: `docker build --build-arg BASE_PRODUCT_VERSION=7.1.0 --build-arg OB_TRUSTED_CERTS_URL=http://localhost:8000/trusted-certs.zip --build-arg WSO2_OB_KEYSTORES_URL=http://localhost:8000/docker-open-banking/samples/keystores/ --build-arg RESOURCE_URL=http://localhost:8000 -t wso2is-ob:4.0.0 .` <br><br>
    * eg:- **Hosted remotely**: `docker build --build-arg BASE_PRODUCT_VERSION=7.1.0 --build-arg OB_TRUSTED_CERTS_URL=http://10.100.8.22:8000/trusted-certs.zip --build-arg WSO2_OB_KEYSTORES_URL=http://10.100.8.22:8000/docker-open-banking/samples/keystores/ --build-arg RESOURCE_URL=http://10.100.8.22:8000 -t wso2is-ob:4.0.0 .`

## Running the Docker Image

Execute the `docker run` command to run the Docker image as a container.

```
docker run -d --name wso2is-ob -p 9443:9443 -p 8243:8243 -p 8280:8280 wso2is-ob:4.0.0
```

```
## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
