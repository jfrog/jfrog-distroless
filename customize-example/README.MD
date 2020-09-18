# Intro
The Dockerfiles in this folder are meant to build JFrog Platform Products for other distros of Linux to met various certification or compliance requirements for customer installations.

# Redhat UBI

## Artifactory
To build Artifactory for Redhat UBI w/ Dockerfile.redhat-ubi-rt7, use build argument with the correct version of Artifactory: 

```--build-arg ARTIFACTORY_BASE_VERSION={LATEST_VERSION}```

Example:
 
```docker build -f Dockerfile.redhat-ubi-rt7 --build-arg ARTIFACTORY_BASE_VERSION={LATEST_VERSION} -t {IMAGE_NAME} .```

Versions of Artifactory: 
https://bintray.com/jfrog/reg2/jfrog%3Aartifactory-pro

## Xray

To build Xray for Redhat UBI you will need to build each Xray image below:

````bash
Dockerfile.redhat-ubi-xray-analysis
Dockerfile.redhat-ubi-xray-indexer
Dockerfile.redhat-ubi-xray-persist
Dockerfile.redhat-ubi-xray-server
Dockerfile.redhat-ubi-xray-router
Dockerfile.redhat-ubi-xray-rabbitmq
````

For Xray Analysis, Indexer, Persist, or Server include the build arg:
````bash 
XRAY_BASE_VERSION
````

For Xray Router include the build arg:

````bash
ROUTER_BASE_VERSION
````

Xray Example:
 
````bash
docker build -f Dockerfile.redhat-ubi-xray-analysis --build-arg XRAY_BASE_VERSION={LATEST_VERSION} -t {IMAGE_NAME} .
````

Router Example:
 
````bash
docker build -f Dockerfile.redhat-ubi-xray-router --build-arg ROUTER_BASE_VERSION={LATEST_VERSION} -t {IMAGE_NAME} .
````

Versions of Xray: 
https://bintray.com/jfrog/reg2/jfrog%3Axray-server

Versions of Router: 
https://bintray.com/jfrog/reg2/jfrog%3Arouter

## Pipelines

To build Pipelines for Redhat UBI will need to build each of the pipelines images below:

````bash
Dockerfile.redhat-ubi-pipelines-api
Dockerfile.redhat-ubi-pipelines-installer
Dockerfile.redhat-ubi-pipelines-k8snode
Dockerfile.redhat-ubi-pipelines-micro
Dockerfile.redhat-ubi-pipelines-router
Dockerfile.redhat-ubi-pipelines-www
````

For Pipelines Api, Installer, K8snode, Micro, or WWW include the build arg:
````bash 
PIPELINES_BASE_VERSION
````

For Pipelines Router include the build arg:

````bash
ROUTER_BASE_VERSION
````

Pipelines Example:
 
````bash
docker build -f Dockerfile.redhat-ubi-pipelines-api --build-arg PIPELINES_BASE_VERSION={PIPELINES_LATEST_VERSION} -t {IMAGE_NAME} .
````

Router Example:
 
````bash
docker build -f Dockerfile.redhat-ubi-pipelines-router --build-arg ROUTER_BASE_VERSION={ROUTER_LATEST_VERSION} -t {IMAGE_NAME} .
````


Versions of Pipelines: 
https://bintray.com/jfrog/reg2/jfrog%3Apipelines-api

Versions of Router: 
https://bintray.com/jfrog/reg2/jfrog%3Arouter
