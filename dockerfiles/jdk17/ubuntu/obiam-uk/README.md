# Dockerfile for WSO2 Open Banking Identity & Access Management UK Toolkit Module
This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image for WSO2 Open Banking Identity & Access Management UK Toolkit Module with WSO2 IS 6.0.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v20.10.10 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client
* WSO2 Open Banking Identity & Access Management UK Toolkit Module pack 
* Download the WSO2 IS Connector to configure the Identity Server with the API Manager. Please go through this [link](https://ob.docs.wso2.com/en/latest/get-started/quick-start-guide/#installing-base-products) to find respective WSO2 IS Connector according to the API Manager version. Extract the dowloaded WSO2 IS Connector into your local machine.
    + Host the downloaded artifacts locally or on a remote location.
    > The hosted locations of artifacts will be passed as the build arguments when building the Docker image.<br>
    > 1. **WSO2_OB_TOOLKIT_DIST_URL** - UK Toolkit location

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-open-banking.git
```

> The local copy of the `jdk17/dockerfiles/ubuntu/obiam-uk` directory will be referred to as `OBIAM_UK_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<OBIAM_UK_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build --build-arg BASE_PRODUCT_VERSION=<IS BASE PRODUCT VERSION> --build-arg WSO2_OB_TOOLKIT_DIST_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> -t wso2-obiam-uk:1.0.0-jdk17 .` <br>
    > eg:- **Hosted locally**: `docker build --build-arg BASE_PRODUCT_VERSION=6.0.0 --build-arg WSO2_OB_TOOLKIT_DIST_URL=http://localhost:8000/wso2-obiam-toolkit-uk-1.0.0.tar.gz -t wso2-obiam-uk:1.0.0-jdk17 .` <br><br>
    > eg:- **Hosted remotely**: `docker build --build-arg BASE_PRODUCT_VERSION=6.0.0 --build-arg WSO2_OB_TOOLKIT_DIST_URL=http://<public_ip:port>/wso2-obiam-toolkit-uk-1.0.0.tar.gz -t wso2-obiam-uk:1.0.0-jdk17 .`

##### 3. Running the Docker image.
if you are only using the WSO2 Open Banking Identity Server, please run the below command.
> - `docker run -it -p 9446:9446 wso2-obiam-uk:1.0.0-jdk17`

If you are using WSO2 Open Banking Identity Server and WSO2 Open Banking API Manager,  please run the below command.
> - `docker run -it -p 9446:9446 -v <IS_CONNECTOR_HOME>/dropins:/home/wso2carbon/wso2-artifact-volume/repository/components/dropins/ -v <IS_CONNECTOR_HOME>/webapps:/home/wso2carbon/wso2-artifact-volume/repository/deployment/server/webapps/ wso2-obiam-uk:1.0.0-jdk17`
> In here, <IS_CONNECTOR_HOME> refers to the root directory path of the extracted WSO2 IS Connector.

##### 4. Accessing management console.

- To access the management console, use the docker host IP and port 9446.
    + `https:<DOCKER_HOST>:9446/carbon`
    
> In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `deployment.toml` is as follows:

##### 1. Stop the Identity & Access Management Module container if it's already running.

In WSO2 Open Banking Identity & Access Management UK Toolkit 1.0.0 product distribution, `deployment.toml` configuration file <br>
can be found at `<DISTRIBUTION_HOME>/repository/conf`. Copy the file to some suitable location of the host machine, <br>
referred to as `<SOURCE_CONFIGS>/deployment.toml` and change the offset value under ports to 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/deployment.toml`.

```
chmod o+r <SOURCE_CONFIGS>/deployment.toml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run \
-p 9447:9447 \
--volume <SOURCE_CONFIGS>/deployment.toml:<TARGET_CONFIGS>/deployment.toml \
wso2-obiam-uk:1.0.0-jdk17
```

> In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2is-6.0.0/repository/conf folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
