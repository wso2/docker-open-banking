# WSO2 Open Banking API Manager and Open Banking Key Manager with Open Banking Business Intelligence
 

## Prerequisites

 * Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
   in order to run the steps provided in following **Quick Start Guide**. <br><br>
 * In order to use WSO2 Open Banking Docker images, you need an active WSO2 Open Banking subscription. If you do not possess an active WSO2
   Open Banking subscription, you can contact us from [here](https://wso2.com/solutions/financial/open-banking/).<br><br>
 * If you wish to run the Docker Compose setup using Docker images built locally, build Docker images using Docker resources available from [here](../../dockerfiles/) and remove the `docker.wso2.com/` prefix from the `image` name in the `docker-compose.yml`. <br><br>
    
## Quick Start Guide

1. Clone WSO2 Open Banking Docker Git repository.

    ```
    git clone https://github.com/wso2/docker-open-banking.git
    ```
    > If you are to try out an already released zip of this repo, please ignore this 1st step. 

2. Switch to the `docker-compose/obam-obkm-with-obbi` folder.

    ```
    cd docker-open-banking/docker-compose/obam-obkm-with-obbi
    ```
    > If you are to try out an already released zip of this repo, please ignore this 2nd step also. 
     Instead, extract the zip file and directly browse to `docker-open-banking-<released-version-here>/docker-compose/obam-obkm-with-obbi` folder. 
     
    > If you want to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
     i.e. for example: git checkout tags/v1.4.0.5 and continue below steps.

3. Execute the `deploy.sh` script to start the deployment.
   ```
   ./deploy.sh
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

 Access the WSO2 Open Banking Business Intelligence web UIs using the below URLs via a web browser.

  ```
   https://localhost:9643/portal
   https://localhost:9643/business-rules
   https://localhost:9643/monitoring
   https://localhost:9643/policies
  ```
 
 Access the servers using following credentials.
    
 * Username: admin@wso2.com <br>
 * Password: wso2123

5. Follow the documentation to use WSO2 Open Banking:

a. To deploy APIs
    * [Deploying APIs for UK](https://docs.wso2.com/display/OB200/Deploying+APIs+for+UK)
    * [Deploying APIs for Berlin](https://docs.wso2.com/display/OB200/Deploying+APIs+for+Berlin)
    * [Deploying APIs for AU](https://docs.wso2.com/display/OB200/Deploying+APIs+for+Australia)

b. To try out the solution:
    * [Try Out WSO2 Open Banking UK](https://docs.wso2.com/display/OB200/Try+Out+WSO2+Open+Banking+UK)
    * [Try Out WSO2 Open Banking Berlin](https://docs.wso2.com/display/OB200/Try+Out+WSO2+Open+Banking+Berlin?src=sidebar)
    * [Try Out WSO2 Open Banking AU](https://docs.wso2.com/display/OB200/Try+Out+WSO2+Open+Banking+Au)

For more information, see [WSO2 Open Banking documentation](https://docs.wso2.com/display/OB200).
