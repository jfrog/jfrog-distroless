To build Dockerfile.redhat-ubi-rt7, use build argument with the correct version of Artifactory: 

```--build-arg ARTIFACTORY_BASE_VERSION={LATEST_VERSION}```

Example:
 
```docker build -f Dockerfile.redhat-ubi-rt7 --build-arg ARTIFACTORY_BASE_VERSION={LATEST_VERSION} -t {IMAGE_NAME} .```

Versions of Artifactory: 
https://bintray.com/jfrog/reg2/jfrog%3Aartifactory-pro