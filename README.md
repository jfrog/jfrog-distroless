# JFrog distroless base images 
This project is based on Google [distroless](https://github.com/GoogleContainerTools/distroless) project 
and build using [Bazel](https://bazel.build/) build tool

##Pipeline test new

# Goal
Create a light weight image with no security vulnerabilities 

## Build Image
To build all images run the following in the root directory, it expect BUILD_NUMBER (Jenkins Ready) to be pre set.
```bash
# Set BUILD_NUMBER for local use
export BUILD_NUMBER=0.1-test

# Run the bazel build
bazel build all
```

If you want to build specific image you can run
```bash
bazel build base/base
```

To tag the images like stated in the root BUILD file run
```bash
bazel run all
```

If you don't have `bazel` installed you can use the docker bazel builder image by
```bash
# CD into the Dockerfile directory
cd docker-bazel-builder

# Build the Docker image
docker build -f Dockerfile.bazel-builder -t bazel-docker-builder:latest .

# Go back to repository root
cd ../

# Run the bazel build
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/usr/src/app -e BUILD_NUMBER=11 bazel-docker-builder:latest bash -c "bazel build all && bazel test --test_output=errors --curses=no //..."
```

## Installed Resources
* Debian files: Debian repo is declared in the [WORKSPACE](WORKSPACE) file, it is currently pointing to a [dedicated Artifactory instance](https://deepscan.jfrog.io/deepscan) 

To install new debian you need to declare it in the [WORKSPACE](WORKSPACE) in the dpkg_list and in the BUILD file in the debs section of the image.

* Resources that are not available as deb files can be installed as tar files. The download resource is define as http_archive in the [WORKSPACE](WORKSPACE) file and you build them under experimental directory, last command should tar it then you can 
add them as tar action during the image build.

## Custom Artifactory Docker image
In some cases, you'll want to customise the Artifactory Docker image and add more tools or do some other customisations to it.<br>
See [customize-example](customize-example) directory with a couple of Dockerfiles as examples of how this can be done.

**NOTE:** These are examples only and are meant to be extended as needed!
