# Dockerfile for Dashboard Profile of WSO2 Open Banking Business Intelligence #

This section defines the step-by-step instructions to build [Alpine](https://hub.docker.com/_/alpine/) Linux based Docker image for Dashboard profile of
WSO2 Open Banking Business Intelligence 2.0.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client

* WSO2 Open Banking Business Intelligence pack downloaded through [WUM](https://docs.wso2.com/display/OB200/Setting+Up+Servers)
    + Host the downloaded pack locally or on a remote location.
    > The hosted location will be passed as the build argument `WSO2_SERVER_DIST_URL` when building the Docker image. 

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-open-banking.git
```

> The local copy of the `dockerfile/alpine/obbi/dasboard` directory will be referred to as `OBBI_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<OBBI_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build --build-arg WSO2_SERVER_DIST_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> -t wso2-obbi-dashboard:2.0.0-alpine .`
    > eg:- Hosted locally: `docker build --build-arg WSO2_SERVER_DIST_URL=http://172.17.0.1:8000/wso2-obbi-2.0.0.zip -t wso2-obbi-dashboard:2.0.0-alpine .`
    > eg:- Hosted remotely: `docker build --build-arg WSO2_SERVER_DIST_URL=http://<pubic_ip:port>/wso2-obbi-2.0.0.zip -t wso2-obbi-dashboard:2.0.0-alpine .`
    
##### 3. Running Docker images specific to each profile.

- `docker run -p 9643:9643 wso2-obbi-dashboard:2.0.0-alpine`
> Here, only port 9643 has been mapped to a Docker host port.
You may map other container service ports, which have been exposed to Docker host ports, as desired.

##### 4. Accessing the Dashboard portal.

- For dashboard,
    + `https:<DOCKER_HOST>:9643/portal`
    
> In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `deployment.yaml` is as follows:

##### 1. Stop the Open Banking Business Intelligence container if it's already running.

In WSO2 Open Banking Business Intelligence 2.0.0 product distribution, `deployment.yaml` configuration file <br>
can be found at `<DISTRIBUTION_HOME>/conf/dashboard`. Copy the file to some suitable location of the host machine, <br>
referred to as `<SOURCE_CONFIGS>/deployment.yaml` and change the offset value under ports to 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/deployment.yaml`.

```
chmod o+r <SOURCE_CONFIGS>/deployment.yaml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run 
-p 9641:9641
--volume <SOURCE_CONFIGS>/deployment.yaml:<TARGET_CONFIGS>/deployment.yaml
wso2-obbi-dashboard:2.0.0-alpine
```

> In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2-obbi-2.0.0/conf/dashboard folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
