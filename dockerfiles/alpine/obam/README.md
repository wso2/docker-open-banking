# Dockerfile for WSO2 Open Banking API Manager #
This section defines the step-by-step instructions to build an [Alpine](https://hub.docker.com/_/alpine/) Linux based Docker image for WSO2 Open Banking API Manager.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client
* WSO2 Open Banking API Manager pack downloaded through [WUM](https://docs.wso2.com/display/OB140/Setting+Up+Servers)
    + Host the downloaded pack locally or on a remote location.
    > The hosted location will be passed as the build argument `WSO2_SERVER_DIST_URL` when building the Docker image. 

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-open-banking.git
```

> The local copy of the `dockerfiles/alpine/obam` directory will be referred to as `OBAM_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<OBAM_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build --build-arg WSO2_SERVER_DIST_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> -t wso2-obam:1.4.0-alpine .`
    > eg:- Hosted locally: `docker build --build-arg WSO2_SERVER_DIST_URL=http://172.17.0.1:8000/wso2-obam-1.4.0.zip -t wso2-obam:1.4.0-alpine .`
    > eg:- Hosted remotely: `docker build --build-arg WSO2_SERVER_DIST_URL=http://<public_ip:port>/wso2-obam-1.4.0.zip -t wso2-obam:1.4.0-alpine .`
    
##### 3. Running the Docker image.

- `docker run -it -p 9443:9443 wso2-obam:1.4.0-alpine`

##### 4. Accessing management console.

- To access the management console, use the docker host IP and port 9443.
    + `https:<DOCKER_HOST>:9443/carbon`
    
> In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `carbon.xml` is as follows:

##### 1. Stop the API Manager container if it's already running.

In WSO2 Open Banking API Manager 1.4.0 product distribution, `carbon.xml` configuration file <br>
can be found at `<DISTRIBUTION_HOME>/repository/conf`. Copy the file to some suitable location of the host machine, <br>
referred to as `<SOURCE_CONFIGS>/carbon.xml` and change the offset value under ports to 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/carbon.xml`.

```
chmod o+r <SOURCE_CONFIGS>/carbon.xml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run \
-p 9444:9444 \
--volume <SOURCE_CONFIGS>/carbon.xml:<TARGET_CONFIGS>/carbon.xml \
wso2-obam:1.4.0-alpine
```

> In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2-obam-1.4.0/repository/conf folder of the container.

## How to add a custom keystore

##### 1. Create a new keystore.

Follow the steps given in [Creating a new keystore](https://docs.wso2.com/display/ADMIN44x/Creating+New+Keystores).

##### 2. Import the certificate of the keystores to the truststore.

* Import the public key certificate of the new server keystore to the truststore of WSO2 Open Banking API Manager.
* If there are any client certificates, import them to the truststore as well.

##### 3. Add the new keystore and truststore to WSO2 Open Banking API Manager.

* Copy the generated keystore to `<DISTRIBUTION_HOME>/repository/resources/security`.
* Replace the existing `<DISTRIBUTION_HOME>/repository/resources/security/client-truststore.jks` with the truststore updated in step 2
* To configure the keystore and trustore follow [Configuring KeyStores](https://docs.wso2.com/display/ADMIN44x/Configuring+Keystores+in+WSO2+Products).

##### 4. Build the Docker Image for Open Banking API Manager.

Build the Docker Image following the above steps.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
