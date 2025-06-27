# Dockerfile for WSO2 Financial Services Identity & Access Management Accelerator Module #
This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image for WSO2 Financial Services Identity & Access Management Module.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v20.10.10 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client
  * WSO2 Financial Services Identity & Access Management Accelerator Module pack downloaded through [WSO2 Updates 2.0](https://ob.docs.wso2.com/en/latest/install-and-setup/setting-up-servers/)
    * Zip archive file of the Open Banking root and issuer certificates.

      * Download the root and issuer [certificates](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/252018873/OB+Root+and+Issuing+Certificates+for+Sandbox).
      * Rename the `OB_SandBox_PP_Root.cer` as `root.cer`.
      * Rename the `OB_SandBox_PP_Issuing.cer` as `iss.cer`.
      * Zip the root.cer and iss.cer in one zip archive file.

      * Keystores directory of wso2 server certs of WSO2 Financial Services Docker Images. (https://github.com/wso2/docker-open-banking/raw/v4.0.0.1/dockerfiles/keystores)

        * Host the downloaded artifacts locally or on a remote location.
          - The hosted locations of artifacts will be passed as the build arguments when building the Docker image.<br>
            1. **WSO2_OB_ACCELERATOR_DIST_URL** - Accelerator location
            2. **OB_TRUSTED_CERTS_URL** - Zip archive location of the certificates of WSO2 Financial Services root and issuer
            3. **WSO2_OB_KEYSTORES_URL** - Location of keystores folder of wso2 server certs


## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-open-banking.git
```
> The local copy of the `jdk11/dockerfiles/ubuntu/fsiam` directory will be referred to as `FSIAM_DOCKERFILE_HOME` from this point onwards.

##### 2. Setup the database

- Create databases and tables by refereing to [Setting Up Databases](https://ob.docs.wso2.com/en/latest/install-and-setup/setting-up-databases/)

##### 3. Update the Dockerfile with MySQL configs and hostnames

- Open the  `<FSIAM_DOCKERFILE_HOME>/Dockerfile`  and update the following values.

  ```
  ARG IS_HOSTNAME=<IAM_HOSTNAME>
  
  ARG DB_TYPE=mysql
  ARG DB_USER=<MYSQL_USER_NAME>
  ARG DB_PASS=<MYSQL_USER_PASSWORD>
  ARG DB_HOST=<MYSQL_HOSTNAME>
  ARG DB_DRIVER=com.mysql.jdbc.Driver
  ```

##### 4. Build the Docker image.

- Navigate to `<FSIAM_DOCKERFILE_HOME>` directory
- Execute `docker build` command as shown below.
    ```
    docker build --build-arg BASE_PRODUCT_VERSION=<IS BASE PRODUCT VERSION> --build-arg WSO2_OB_ACCELERATOR_DIST_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> --build-arg OB_TRUSTED_CERTS_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> --build-arg WSO2_OB_KEYSTORES_URL=<URL_OF_THE_HOSTED_LOCATION/FOLDER_NAME> -t wso2-fsiam:4.0.0-jdk11 .
    ```

  * eg:- **Hosted locally**: `docker build --build-arg BASE_PRODUCT_VERSION=7.1.0 --build-arg WSO2_OB_ACCELERATOR_DIST_URL=http://localhost:8000/wso2-fsiam-accelerator-4.0.0.tar.gz --build-arg OB_TRUSTED_CERTS_URL=http://localhost:8000/fs-cert.zip --build-arg WSO2_OB_KEYSTORES_URL=https://github.com/wso2/docker-open-banking/raw/v4.0.0.1/dockerfiles/keystores  -t wso2-fsiam:4.0.0-jdk11 .` <br><br>
  * eg:- **Hosted remotely**: `docker build --build-arg BASE_PRODUCT_VERSION=7.1.0 --build-arg WSO2_OB_ACCELERATOR_DIST_URL=http://<public_ip:port>/wso2-fsiam-accelerator-4.0.0.tar.gz --build-arg OB_TRUSTED_CERTS_URL=http://<public_ip:port>/fs-cert.zip --build-arg WSO2_OB_KEYSTORES_URL=https://github.com/wso2/docker-open-banking/raw/v4.0.0.1/dockerfiles/keystores  -t wso2-fsiam:4.0.0-jdk11 .`

##### 5. Running the Docker image.
if you are only using the WSO2 Financial Services Identity Server, please run the below command.
  ```
  docker run -it -p 9446:9446 wso2-fsiam:4.0.0-jdk11
  ```

- If you want to Docker mount the database connector file to the container run below command.
  ```
  docker run -it -v <LOCAL_PATH_TO_CONNECTOR:<PATH_TO_IS_LIBS_FOLDER_IN_CONTAINER>  -p 9446:9446 wso2-fsiam:4.0.0-jdk11
  ```

##### 4. Accessing management console.

- To access the management console, use the docker host IP and port 9446.
  + `https:<DOCKER_HOST>:9446/carbon`

> In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `deployment.toml` is as follows:

##### 1. Stop the Identity & Access Management Module container if it's already running.

In WSO2 Financial Services Identity & Access Management Module 4.0.0 product distribution, `deployment.toml` configuration file <br>
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
wso2-fsiam:4.0.0-jdk11
```

> In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2is-7.1.0/repository/conf folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
