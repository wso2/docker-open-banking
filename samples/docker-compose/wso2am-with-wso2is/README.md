# WSO2 Open Banking API Manager with Open Banking Identity & Access Management Accelerator Module


## Prerequisites

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
  in order to run the steps provided in following **Quick Start Guide**. <br><br>
* In order to use WSO2 Docker images, you need an active WSO2 Open Banking subscription. If you do not possess an active WSO2
  Open Banking subscription, you can contact us from [here](https://wso2.com/solutions/financial/open-banking/) <br><br>
* Containerized docker images for WSO2 IS with WSO2 OBIAM Accelerator and WSO2 AM with WSO2 OBAM Accelerator.
 - The docker images for WSO2 Financial Services Accelerator Modules are not designed to run indivitually. Users have to use the Docker Image and build the container images for WSO2 Base Products with Financial Services Accelerator Modules.
    Please refer to the sample Dockerfiles file written in the `samples/wso2am_with_obam` and `samples/wso2is_with_obiam` directory for sample docker files.

## Quick Start Guide

1. Clone WSO2 Open Banking Docker Git repository.

    ```
    git clone https://github.com/wso2/docker-open-banking.git
    ```

2. Switch to the `docker-open-banking/samples/docker-compose/wso2am-with-wso2is` folder.

    ```
    cd docker-open-banking/samples/docker-compose/wso2am-with-wso2is
    ```
3. Setup Databases for WSO2 API Manager and WSO2 Open Banking Identity Server.
   - Follow the instructions provided in [Setting up Databases](https://ob.docs.wso2.com/en/latest/install-and-setup/setting-up-databases/) to setup the databases.

4. Execute following Docker Compose command to start the deployment of WSO2 Open Banking Accelerator setup.
   ```
   docker-compose up
   ```
5. Access the WSO2 Open Banking API Manager web UIs using the below URLs via a web browser.

   ```
   https://obam:9443/publisher
   https://obam:9443/devportal
   https://obam:9443/admin
   https://obam:9443/carbon
   ```

   Access the servers using following credentials.
   ````  
   * Username: am_admin@wso2.com 
   * Password: wso2123
   ````
   Please note that API Gateway will be available on following ports.
   ```
   https://obam:8243
   http://obam:8280
   ```

6. WSO2 Open Banking API Manager will use WSO2 Open Banking Identity & Access Management Module to generate OAuth2 tokens and validate those tokens during API invocations. You can access the WSO2 Open Banking Identity & Access Management Module-Management portal using the below URL via a web browser.

   ```
   https://obiam:9446/console
   ```

   Access the servers using following credentials.
   ````  
   * Username: is_admin@wso2.com 
   * Password: wso2123
   ````
7. Follow the documentation to use WSO2 Open Banking:

   To try out the solution: [Try Out WSO2 Open Banking](https://ob.docs.wso2.com/en/latest/get-started/quick-start-guide/)

For more information, see [WSO2 Open Banking documentation](https://ob.docs.wso2.com/en/latest/develop/developer-guide/).
