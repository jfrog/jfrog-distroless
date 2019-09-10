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
    username = "root",
)

passwd_entry(
    name = "xray_user",
    gid = 1035,
    uid = 1035,
    username = "xray",
)

passwd_tar(
    name = "passwd",
    entries = [
        ":root_user",
        ":xray_user",
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
    name = "xray_group",
    gid = 1035,
    groupname = "xray",
)
group_file(
    name = "group",
    entries = [
        ":root_group",
        ":xray_group",
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
    name = "xray-go",
    base = "//base:debug",
    stamp = True,
    debs = [
            	packages["bash"],
                packages["dash"],
#                packages["zip"],
                packages["libtinfo5"],
                packages["zlib1g"],
                packages["libstdc++6"],
                packages["libgcc1"],
                packages["db-util"],
                packages["db5.3-util"],
                packages["libdb5.3"],
                # PostgreSQL client ->
                packages["postgresql-client-9.6"],
                packages["postgresql-client-common"],
                packages["perl"],
                packages["perl-base"],
                packages["perl-modules-5.24"],
                packages["libperl5.24"],
                packages["libpq5"],
                packages["libedit2"],
                packages["libc-bin"],
                packages["libgssapi-krb5-2"],
                packages["libldap-2.4-2"],
                packages["libncurses5"],
                packages["libbsd0"],
                packages["libkrb5-3"],
                packages["libk5crypto3"],
                packages["libcom-err2"],
                packages["libkrb5support0"],
                packages["libkeyutils1"],
                packages["libsasl2-2"],
                packages["libgnutls30"],
                packages["libp11-kit0"],
                packages["libidn11"],
                packages["libtasn1-6"],
                packages["libnettle6"],
                packages["libhogweed4"],
                packages["libgmp10"],
                packages["libffi6"],
                # <- PostgreSQL client
            ],
    tars = [
            ":passwd",
            ":group_tar",
        ],
    entrypoint = ["/busybox/sh"]
)
container_test(
    name = "creds_test",
    configs = ["testdata/creds.yaml"],
    image = ":xray-go",
)

container_test(
    name = "db_test",
    configs = ["testdata/db.yaml"],
    image = ":xray-go",
)

load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish",
   image = ":xray-go",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/xray-go",
   tag =  "@BUILD_NUMBER@",
)