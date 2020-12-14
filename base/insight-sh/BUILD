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

# Create /etc/passwd with the elasticsearch user
passwd_entry(
    name = "elasticsearch_user",
    gid = 1000,
    uid = 1000,
    home = "/home/elasticsearch",
    username = "elasticsearch",
)

passwd_entry(
    name = "jfmc_user",
    gid = 1050,
    uid = 1050,
    home = "/home/jfmc",
    username = "jfmc",
)

passwd_tar(
    name = "passwd",
    entries = [
        ":root_user",
        ":jfmc_user",
        ":elasticsearch_user",
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
    name = "jfmc_group",
    gid = 1050,
    groupname = "jfmc",
)

group_entry(
    name = "elasticsearch_group",
    gid = 1000,
    users = ["jfmc", "elasticsearch"],
    groupname = "elasticsearch",
)

group_file(
    name = "group",
    entries = [
        ":root_group",
        ":jfmc_group",
        ":elasticsearch_group",
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
    name = "insight-sh",
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
    name = "insight_test",
    configs = ["testdata/creds.yaml"],
    image = ":insight-sh",
)


load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish",
   image = ":insight-sh",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/insight-sh",
   tag =  "@BUILD_NUMBER@",
)
