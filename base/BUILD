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

passwd_tar(
    name = "passwd",
    entries = [
        ":root_user",
    ],
    passwd_file_pkg_dir = "etc",
)

# Create /etc/group with the root group
group_entry(
    name = "root_group",
    gid = 0,
    groupname = "root",
)

group_file(
    name = "group",
    entries = [
        ":root_group",
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
load("//locale:locale.bzl", "locale")

cacerts(
    name = "cacerts",
    deb = packages["ca-certificates"],
)

locale(
    name = "locale",
    deb = packages["libc-bin"],
)

# Create /tmp, too many things assume it exists.
# tmp.tar has a /tmp with the correct permissions 01777
# A tar is needed because at the moment there is no way to create a
# directory with specific permissions.

docker_build(
    name = "static",
    debs = [
        packages["libc6"],
        packages["bash"],
        packages["dash"],
        packages["libtinfo6"],
        packages["base-files"],
        packages["netbase"],
        packages["tzdata"],
        packages["libc-bin"],
        packages["libselinux1"],
        packages["libncurses6"],
        packages["ncurses-base"],
        packages["libncursesw6"],
        packages["ncurses-bin"],
        packages["libprocps7"],
        packages["procps"],
        packages["libsystemd0"],
        packages["liblzma5"],
        packages["liblz4-1"],
        packages["libgcrypt20"],
        packages["libgpg-error0"],
        packages["coreutils"],
        packages["gzip"],
        packages["grep"],
        packages["unzip"],
        packages["sed"],
        packages["findutils"],
        packages["original-awk"],
        packages["tar"],
        packages["inetutils-tools"],
        packages["util-linux"],
        packages["libpcre3"],
        packages["libbz2-1.0"],
        packages["libattr1"],
        packages["libacl1"],
        packages["hostname"],
        packages["vim-tiny"],
        packages["vim-common"],
        packages["wget"],
        packages["libpcre2-8-0"],
        packages["libgnutls30"],
        packages["libidn2-0"],
        packages["libnettle6"],
        packages["libpsl5"],
        packages["libuuid1"],
        packages["libgmp10"],
        packages["libhogweed4"], 
        packages["libp11-kit0"], 
        packages["libtasn1-6"],  
        packages["libunistring2"],
        packages["libffi6"],
        packages["debianutils"],
        packages["libpcap0.8"],
        packages["tcpdump"],
        packages["lsof"],
        packages["tree"],
        ":cacerts.deb",
    ],
    env = {
        "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        # allows openssl to find the certificates by default
        # TODO: We should run update-ca-certifaces, but that requires "openssl rehash"
        # which would probably need to be run inside the container
        "SSL_CERT_FILE": "/etc/ssl/certs/ca-certificates.crt",
        "LANG": "C.UTF-8",
    },
    tars = [
        ":passwd",
        ":group_tar",
        ":tmp.tar",
        ":nsswitch.tar",
        "@debian_buster//file:os_release.tar",
    ],
    symlinks = {
            "/usr/bin/awk": "/usr/bin/original-awk",
            "/usr/bin/vi": "/usr/bin/vim.tiny",
    },
)

docker_build(
    name = "base",
    base = ":static",
    debs = [
        packages["libc6"],
        packages["bash"],
        packages["dash"],
        packages["libtinfo6"],
        packages["libncurses6"],
        packages["libncursesw6"],
        packages["ncurses-base"],
        packages["ncurses-bin"],
        packages["libprocps7"],
        packages["procps"],
        packages["libsystemd0"],
        packages["liblzma5"],
        packages["liblz4-1"],
        packages["libgcrypt20"],
        packages["libgpg-error0"],
        packages["libssl1.1"],
        packages["openssl"],
        packages["libselinux1"],
        packages["coreutils"],
        packages["gzip"],
        packages["grep"],
        packages["unzip"],
        packages["sed"],
        packages["findutils"],
        packages["original-awk"],
        packages["tar"],
        packages["inetutils-tools"],
        packages["util-linux"],
        packages["libpcre3"],
        packages["libbz2-1.0"],
        packages["libattr1"],
        packages["libacl1"],
        packages["hostname"],
        packages["vim-tiny"],
        packages["vim-common"],
        packages["wget"],
        packages["libpcre2-8-0"],
        packages["libgnutls30"],
        packages["libidn2-0"],
        packages["libnettle6"],
        packages["libpsl5"],
        packages["libuuid1"],
        packages["libgmp10"],
        packages["libhogweed4"], 
        packages["libp11-kit0"], 
        packages["libtasn1-6"],  
        packages["libunistring2"],
        packages["libffi6"],
        packages["debianutils"],
        packages["libpcap0.8"],
        packages["tcpdump"],
        packages["lsof"],
        packages["tree"],
    ],
    stamp = True,
    symlinks = {
            "/usr/bin/awk": "/usr/bin/original-awk",
            "/usr/bin/vi": "/usr/bin/vim.tiny",
    },
)

# A debug image available.
docker_build(
    name = "debug",
    base = ":base",
    directory = "/",
    entrypoint = ["/bin/sh"],
    env = {"PATH": "$PATH:/curl"},
    tars = ["//experimental/curl:curl.tar"],
     stamp = True,
)

container_test(
    name = "debug_test",
    configs = ["testdata/debug.yaml"],
    image = ":debug",
)

container_test(
    name = "base_test",
    configs = ["testdata/base.yaml"],
    image = ":base",
)

go_binary(
    name = "check_certs",
    srcs = ["testdata/check_certs.go"],
    pure = "on",
)

docker_build(
    name = "check_certs_image",
    base = "//base:base",
    files = [":check_certs"],
    visibility = ["//visibility:private"],
)

container_test(
    name = "certs_test",
    configs = ["testdata/certs.yaml"],
    image = ":check_certs_image",
)

load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish-static",
   image = ":static",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/go",
   tag =  "@BUILD_NUMBER@",
)

container_push(
   name = "publish",
   image = ":base",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/base",
   tag =  "@BUILD_NUMBER@",
)
container_push(
   name = "publish-debug",
   image = ":debug",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/base",
   tag =  "@BUILD_NUMBER@-debug",
)