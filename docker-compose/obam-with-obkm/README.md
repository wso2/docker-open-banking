# WSO2 Open Banking API Manager with Open Banking Key Manager


## Prerequisites

 * Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
   in order to run the steps provided in following **Quick Start Guide**. <br><br>
 * In order to use WSO2 Open Banking Docker images, you need an active WSO2 Open Banking subscription. If you do not possess an active WSO2
   Open Banking subscription, you can contact us for a Free Trial Subscription from [here](https://wso2.com/solutions/financial/open-banking/).<br><br>
 * If you wish to run the Docker Compose setup using Docker images built locally, build Docker images using Docker resources available from [here](../../dockerfiles/) and remove the `docker.wso2.com/` prefix from the `image` name in the `docker-compose.yml`. <br><br>
    
## Quick Start Guide

1. Clone WSO2 Open Banking Docker Git repository.

    ```
    git clone https://github.com/wso2/docker-open-banking.git
    ```
    > If you are to try out an already released zip of this repo, please ignore this 1st step. 

2. Switch to the `docker-compose/obam-with-obkm` folder.

    ```
    cd docker-open-banking/docker-compose/obam-with-obkm
    ```
    > If you are to try out an already released zip of this repo, please ignore this 2nd step also. 
     Instead, extract the zip file and directly browse to `docker-open-banking-<released-version-here>/docker-compose/obam-with-obkm` folder. 
     
    > If you want to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
     i.e. for example: git checkout tags/v1.4.0.1 and continue below steps.

3. Execute following Docker Compose command to start the deployment.
   ```
   docker-compose up
   ```

4. Access the WSO2 Open Banking API Manager web UIs using the below URLs via a web browser.

 ```
   https://localhost:9443/publisher
   https://localhost:9443/store
   https://localhost:9443/admin
   https://localhost:9443/carbon
 ```
 
 Access the servers using following credentials.
    
 * Username: admin@wso2.com <br>
 * Password: wso2123
 
 Please note that API Gateway will be available on following ports.
 ```
    https://localhost:8243
    https://localhost:8280
 ```

 WSO2 Open Banking API Manager will use WSO2 Open Banking Key Manager to generate OAuth2 tokens and validate those tokens during API invocations. You can access the WSO2 Open Banking Key Manager-Management portal using the below URL via a web browser.

```
   https://localhost:9446/carbon
 ```
 
 Access the servers using following credentials.
    
 * Username: admin@wso2.com <br>
 * Password: wso2123