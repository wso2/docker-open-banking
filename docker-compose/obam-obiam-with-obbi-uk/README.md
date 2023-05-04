# WSO2 Open Banking API Manager, Open Banking Identity & Access Management With Open Banking Business Intelligence Accelerator Module


## Prerequisites

 * Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
   in order to run the steps provided in following **Quick Start Guide**. <br><br>
 * In order to use WSO2 Open Banking Docker images, you need an active WSO2 Open Banking subscription. If you do not possess an active WSO2
   Open Banking subscription, you can contact us from [here](https://wso2.com/solutions/financial/open-banking/) <br><br>
 * Download and extract the [WSO2 IS Connector](https://apim.docs.wso2.com/en/4.2.0/assets/attachments/administer/wso2is-extensions-1.6.8.zip) to configure the Identity Server with the API Manager. By default this docker-compose has set up WSO2 Open Banking UK Toolkit Docker images which are based APIM 4.2.0 and IS 6.0.0. 
 * If you wish to use wso2 Open Banking UK Toolkit Docker images with any other base product versions, Download the WSO2 IS Connector according to the API Manager version. Please go through this [link](https://ob.docs.wso2.com/en/latest/get-started/quick-start-guide/#installing-base-products) to find respective WSO2 IS Connector according to the API Manager version.

## Quick Start Guide

1. Clone WSO2 Open Banking Docker Git repository.

    ```
    git clone https://github.com/wso2/docker-open-banking.git
    ```
    > If you are to try out an already released zip of this repo, please ignore this 1st step. 

2. Switch to the `docker-compose/obam-obiam-with-obbi-uk` folder.

    ```
    cd docker-open-banking/docker-compose/obam-obiam-with-obbi
    ```
    > If you are to try out an already released zip of this repo, please ignore this 2nd step also. 
     Instead, extract the zip file and directly browse to `docker-open-banking-<released-version-here>/docker-compose/obam-obiam-with-obbi-uk` folder. 
     
    > If you want to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
     i.e. for example: git checkout tags/v1.4.0.5 and continue below steps.

3. Volume mount the IS connector on the obiam container.
   > Go to the `volume` mount section of the obiam service in the `docker-compose.yml`.
   > Change the root directory path of the extracted WSO2 IS Connector with <IS_CONNECTOR_HOME>.
4. If you wish to run the Docker Compose setup using Docker images built locally, please follow the steps below.
   > 1. Build Docker images using Docker resources available from [here](../../dockerfiles/)
   > 2. Remove the `docker.wso2.com/` prefix from the `image` name in the `docker-compose.yml` and add the version in the local image at the end.
   >> If you dont wish use locally built docker images, please ignore 4th step.
5. If you wish to use WSO2 Open Banking UK Toolkit docker images which are based on different base product versions. please follow the steps below.
   > 1. Change the base product versions of `image` name in the `docker-compose.yml`.
   > 2. Go to `volume` mount section of the mysql service in `docker-compose.yml`.
   > 3. Change the sql script according to yor base product versions. You can find recspective sql script according to your base product versions from [here](../mysql/scripts/).
   >> If you wish to use WSO2 Open Banking UK Toolkit docker images which are based on APIM 4.2.0 and IS 6.0.0, please ignore this 5th step.
6. Execute following Docker Compose command to start the deployment of WSO2 Open Banking UK Toolkit setup.
   ```
   docker-compose up
   ```
7. Access the WSO2 Open Banking API Manager web UIs using the below URLs via a web browser.

   ```
   https://localhost:9443/publisher
   https://localhost:9443/devportal
   https://localhost:9443/admin
   https://localhost:9443/carbon
   ```

   Please note that API Gateway will be available on following ports.
   ```
   https://localhost:8243
   http://localhost:8280
   ```
 
   WSO2 Open Banking API Manager will use WSO2 Open Banking Identity & Access Management Module to generate OAuth2 tokens and validate those tokens during API invocations. You can access the WSO2 Open Banking Identity & Access Management Module-Management portal using the below URL via a web browser.
 
   ```
   https://localhost:9446/carbon
   ```
  
   Access the servers using following credentials.
   ````  
   * Username: admin@wso2.com 
   * Password: wso2123
   ````

8. WSO2 Open Banking Business Intelligence server will serve on port 9444.

9. Follow the documentation to use WSO2 Open Banking:

   To try out the solution: [Try Out WSO2 Open Banking](https://ob.docs.wso2.com/en/latest/get-started/quick-start-guide/)

For more information, see [WSO2 Open Banking documentation](https://ob.docs.wso2.com/en/latest/develop/developer-guide/).

