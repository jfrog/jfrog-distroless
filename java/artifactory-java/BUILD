package(default_visibility = ["//visibility:public"])
load("@io_bazel_rules_docker//contrib:passwd.bzl", "passwd_entry", "passwd_tar")
load("@io_bazel_rules_docker//contrib:group.bzl", "group_entry", "group_file")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")
load("@io_bazel_rules_go//go:def.bzl", "go_binary")
load("@io_bazel_rules_docker//docker:docker.bzl", "docker_build")
load("@package_bundle//file:packages.bzl", "packages")

passwd_entry(
    name = "root_user",
    gid = 0,
    uid = 0,
    username = "root",
)
passwd_entry(
    name = "artifactory_user",
    gid = 1030,
    uid = 1030,
    username = "artifactory",
)

passwd_tar(
    name = "passwd",
    entries = [
        ":root_user",
        ":artifactory_user",
    ],
    passwd_file_pkg_dir = "etc",
)

# Create /etc/group with the root group
group_entry(
    name = "root_group",
    gid = 0,
    groupname = "root",
)

group_entry(
    name = "artifactory_group",
    gid = 1030,
    groupname = "artifactory",
)

group_file(
    name = "group",
    entries = [
        ":root_group",
        ":artifactory_group",
    ],
)

pkg_tar(
    name = "group_tar",
    srcs = [":group"],
    mode = "0644",
    package_dir = "etc",
)

docker_build(
    name = "artifactory-java-base",
    base = "//java:java-base",
    stamp = True,
    tars = [
        ":passwd",
        ":group_tar",
    ],
    entrypoint = ["/bin/sh"]
)

docker_build(
    name = "artifactory-java",
    base = "//java:debug",
    stamp = True,
    tars = [
        ":passwd",
        ":group_tar",
    ],
    entrypoint = ["/bin/sh"]
)

container_test(
    name = "creds_test",
    configs = ["testdata/creds.yaml"],
    image = ":artifactory-java",
)


load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish",
   image = ":artifactory-java",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/artifactory-java",
   tag =  "adoptopenjdk11-@BUILD_NUMBER@",
)

container_push(
   name = "publish-base",
   image = ":artifactory-java-base",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/artifactory-java-base",
   tag =  "adoptopenjdk11-@BUILD_NUMBER@",
)