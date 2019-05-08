package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//docker:docker.bzl", "docker_bundle")

docker_bundle(
    name = "all",
    images = {
        "docker.jfrog.io/jfrog/distroless/base/go:{BUILD_NUMBER}": "//base:static",
        "docker.jfrog.io/jfrog/distroless/base/xray-go:{BUILD_NUMBER}": "//base/xray-go",
        "docker.jfrog.io/jfrog/distroless/base/insight-sh:{BUILD_NUMBER}": "//base/insight-sh",
        "docker.jfrog.io/jfrog/distroless/base/jfmc-sh:{BUILD_NUMBER}": "//base/jfmc-sh",
        "docker.jfrog.io/jfrog/distroless/base/base:{BUILD_NUMBER}": "//base:base",
        "docker.jfrog.io/jfrog/distroless/base/base:{BUILD_NUMBER}-debug": "//base:debug",
        "docker.jfrog.io/jfrog/distroless/base/cc:{BUILD_NUMBER}": "//cc",
        "docker.jfrog.io/jfrog/distroless/base/cc:{BUILD_NUMBER}-debug": "//cc:debug",
        "docker.jfrog.io/jfrog/distroless/base/java-base:{BUILD_NUMBER}": "//java:java-base",
        "docker.jfrog.io/jfrog/distroless/base/java:adoptopenjdk11-{BUILD_NUMBER}": "//java:java11",
        "docker.jfrog.io/jfrog/distroless/base/java:adoptopenjdk11-{BUILD_NUMBER}-debug": "//java:debug",
        "docker.jfrog.io/jfrog/distroless/base/artifactory-java-base:{BUILD_NUMBER}": "//java/artifactory-java:artifactory-java-base",
        "docker.jfrog.io/jfrog/distroless/base/artifactory-java:adoptopenjdk11-{BUILD_NUMBER}": "//java/artifactory-java",
        "docker.jfrog.io/jfrog/distroless/base/access-java:adoptopenjdk11-{BUILD_NUMBER}": "//java/access-java",
        "docker.jfrog.io/jfrog/distroless/base/distribution-java:adoptopenjdk11-{BUILD_NUMBER}": "//java/distribution-java",
        "docker.jfrog.io/jfrog/distroless/base/jfmc-java:adoptopenjdk11-{BUILD_NUMBER}": "//java/jfmc-java",
    },
    stamp = True,
)

load("@io_bazel_rules_docker//contrib:push-all.bzl", "docker_push")

docker_push(
    name = "publish",
    bundle = ":all",
)
