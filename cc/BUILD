package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//docker:docker.bzl", "docker_build")
load("@package_bundle//file:packages.bzl", "packages")

# An intermediate image for Java and other "mostly statically" compiled languages
[docker_build(
    name = "cc" if (not mode) else mode[1:],
    base = "//base" + mode,
    debs = [
        packages["libgcc1"],
        packages["libgomp1"],
        packages["libstdc++6"],
    ],
    stamp = True,
) for mode in [
    "",
    ":debug",
]]

load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish",
   image = ":cc",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/cc",
   tag =  "@BUILD_NUMBER@",
)

container_push(
   name = "publish-debug",
   image = ":debug",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/cc",
   tag =  "@BUILD_NUMBER@-debug",
)