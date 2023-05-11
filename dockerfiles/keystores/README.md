# WSO2 Server Certs of WSO2 Open Banking Docker Images

WSO2 open banking accelerator docker images have changed their hostname as obam, obiam and obbi. Hence WSO2 server certs of all the servers should be changed their hostnames as mentioned in above. Therefore these two keystores contain private keys and public certificates of WSO2 server certs which have already changed their hostnames as above mentioned.

> The keystore named **"private keys.jks"** contains the private keys of wso2 server certs with the aliases listed below.
> 1. wso2carbon-obiam
> 2. wso2carbon-obam
> 3. wso2carbon-obbi


> The keystore named **"public-certs.jks"** contains the public certificates of wso2 server certs with the aliases listed below.
> 1. wso2-obiam
> 2. wso2-obam
> 3. wso2-obbi