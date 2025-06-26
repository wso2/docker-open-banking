# WSO2 Financial Services Identity & Access Management Accelerator Module


## Prerequisites

 * Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
   in order to run the steps provided in following **Quick Start Guide**. <br><br>
 * In order to use WSO2 Financial Services Docker images, you need an active WSO2 Financial Services subscription. If you do not possess an active WSO2
   Financial Services subscription, you can contact us from [here](https://wso2.com/solutions/financial/open-banking/) <br><br> 
 

## Quick Start Guide

1. Clone WSO2 Financial Services Docker Git repository.

    ```
    git clone https://github.com/wso2/docker-open-banking.git
    ```
    > If you are to try out an already released zip of this repo, please ignore this 1st step. 

2. Switch to the `docker-compose/obiam-only` folder.

    ```
    cd docker-open-banking/docker-compose/obiam-only
    ```
    > If you are to try out an already released zip of this repo, please ignore this 2nd step also. 
     Instead, extract the zip file and directly browse to `docker-open-banking-<released-version-here>/docker-compose/obiam-only` folder. 
     
    > If you want to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
     i.e. for example: git checkout tags/v1.4.0.5 and continue below steps.

3. If you wish to run the Docker Compose setup using UK Toolkit Docker Images or Docker images built locally, please follow the steps below.
   > 1. Build Docker images using Docker resources available from [here](../../dockerfiles/) 
   > 2. Remove the `docker.wso2.com/` prefix from the `image` name in the `docker-compose.yml` and change the image name to the image name of the locally built image.

   >> If you don't wish use locally built docker images, please ignore 3rd step.

4. If you wish to use docker images of WSO2 Financial Services solutions which are based on different base product versions. please follow the steps below.
   > 1. Change the base product versions of `image` name in the `docker-compose.yml`.
   > 2. Go to `volume` mount section of the mysql service in `docker-compose.yml`.
   > 3. Change the sql script according to yor base product versions. You can find respective sql script according to your base product versions from [here](../mysql/scripts/).

6. Execute following Docker Compose command to start the deployment of WSO2 Open Banking Accelerator setup.
   ```
   docker-compose up
   ```
7. Access the WSO2 Financial Services Identity & Access Management web UIs using the below URLs via a web browser.
   ```
   https://fsiam:9446/carbon
   ```
  
   Access the servers using following credentials.
   ````  
   * Username: is_admin@wso2.com 
   * Password: wso2123
   ````
8. Follow the documentation to use WSO2 Financial Services Accelerator:

   To try out the solution: [Try Out WSO2 Open Banking](https://ob.docs.wso2.com/en/latest/get-started/quick-start-guide/)

For more information, see [WSO2 Open Banking documentation](https://ob.docs.wso2.com/en/latest/develop/developer-guide/).

