package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//docker:docker.bzl", "docker_build")
load("@io_bazel_rules_docker//contrib:passwd.bzl", "passwd_entry", "passwd_tar")
load("@io_bazel_rules_docker//contrib:group.bzl", "group_entry", "group_file")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")
load("@io_bazel_rules_go//go:def.bzl", "go_binary")

# Create /etc/passwd with the root user
passwd_entry(
    name = "root_user",
    gid = 0,
    uid = 0,
    home = "/root",
    username = "root",
)

passwd_entry(
    name = "distribution_user",
    gid = 1020,
    uid = 1020,
    home = "/home/distribution",
    username = "distribution",
)

passwd_tar(	
    name = "passwd",	
    entries = [	
        ":root_user",	
        ":distribution_user",
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
    name = "distribution_group",
    gid = 1020,
    groupname = "distribution",
)

group_file(
    name = "group",
    entries = [
        ":root_group",
        ":distribution_group",
    ],
)

pkg_tar(
    name = "group_tar",
    srcs = [":group"],
    mode = "0644",
    package_dir = "etc",
)

load("@package_bundle//file:packages.bzl", "packages")
load("//cacerts:cacerts.bzl", "cacerts")

cacerts(
    name = "cacerts",
    deb = packages["ca-certificates"],
)

# Create /tmp, too many things assume it exists.
# tmp.tar has a /tmp with the correct permissions 01777
# A tar is needed because at the moment there is no way to create a
# directory with specific permissions.

docker_build(
    name = "distribution-sh",
    base = "//base:debug",
    debs = [
        	packages["bash"],
            packages["dash"],
            packages["libtinfo6"],
            packages["zlib1g"],
            packages["libstdc++6"],
            packages["libgcc1"],
        ],
    stamp = True,
    tars = [
            ":passwd",
            ":group_tar",
        ],
    entrypoint = ["/busybox/sh"]
)

container_test(
    name = "distribution_test",
    configs = ["testdata/creds.yaml"],
    image = ":distribution-sh",
)


load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish",
   image = ":distribution-sh",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/distribution-sh",
   tag =  "@BUILD_NUMBER@",
)
