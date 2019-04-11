# JFrog distroless base images 

This project is based on Google [distroless](https://github.com/GoogleContainerTools/distroless) project 
and build using [Bazel](https://bazel.build/) build tool

# Goal
Create a light weight image with no security vulnerabilities 

## Build Image

To build all images run **_bazel build all_** standing on the root directory, it expect BUILD_NUMBER (Jenkins Ready) to be pre set.

If you want to build specific image you can run **_bazel build base/base_**.
To tag the images like stated in the root BUILD file run **_bazel run all_**.

If you don't have bazel installed you can use the docker bazel builder image by:
* cd docker-bazel-builder
* docker build -f Dockerfile.bazel-builder -t bazel-docker-builder:latest .
* cd ../
* docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/usr/src/app -e BUILD_NUMBER=11 bazel-docker-builder:latest bash -c "bazel build all && bazel test --test_output=errors --curses=no //..."

## Installed Resources
* Debian files: Debian repo is declared in the WORKSPACE file, it is currently pointing to an Artifactory https://deepscan.jfrog.io/deepscan 

To install new debian you need to declare it in the WORKSPACE in the dpkg_list and in the BUILD file in the debs section of the image.

* Resources that are not available as deb files can be installed as tar files. The download resource is define as http_archive in the WORKSPACE file and you build them under experimental directory, last command should tar it then you can 
add them as tar action during the image build.