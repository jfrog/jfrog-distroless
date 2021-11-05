workspace(name = "distroless")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

git_repository(
    name = "subpar",
    remote = "https://github.com/google/subpar",
    tag = "1.0.0",
)

git_repository(
    name = "io_bazel_rules_go",
    remote = "https://github.com/bazelbuild/rules_go.git",
    tag = "0.16.3",
)

load("@io_bazel_rules_go//go:def.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

load(
    "//package_manager:package_manager.bzl",
    "dpkg_list",
    "dpkg_src",
    "package_manager_repositories",
)

package_manager_repositories()

## This is from release debian repo, the problem is that the Package.gz change so need to update chacksume all the time

## Snapshot repo has folder that Package.gz don't change
dpkg_src(
    name = "debian_buster",
    arch = "amd64",
    distro = "buster",
    sha256 = "e096054471ae9a772fa67006cd0d9a0b125bb30443625fb6b66935e2a9331e98",
    snapshot = "20210216T210840Z",
    url = "https://snapshot.debian.org/archive",
)

dpkg_src(
    name = "debian_buster_security",
    package_prefix = "https://snapshot.debian.org/archive/debian-security/20210216T201258Z/",
    packages_gz_url = "https://snapshot.debian.org/archive/debian-security/20210216T201258Z/dists/buster/updates/main/binary-amd64/Packages.gz",
    sha256 = "979b105c890ce629a002d66c79b67381c5b78b4769abbeddad3a57225c1c1159",
)

dpkg_list(
    name = "package_bundle",
    packages = [
        # Version required to skip a security fix to the pre-release library
        # TODO: Remove when there is a security fix or dpkg_list finds the recent version
        "libc6",
        "libc-bin",
        "base-files",
        "ca-certificates",
        "openssl",
        "libssl1.1",
        "libtinfo6",
        "netbase",
        "tzdata",
        "bash",
        "dash",
        "net-tools",
        "procps",
        "libprocps7",
        "libsystemd0",
        "libselinux1",
        "libpcre3",
        "liblzma5",
        "liblz4-1",
        "libgcc1",
        "libgomp1",
        "libstdc++6",
        "zlib1g",
        "libgcrypt20",
        "libgpg-error0",
        "libpng16-16",
        "libfreetype6",
        "fonts-dejavu-core",
        "fontconfig-config",
        "libfontconfig1",
        "libexpat1",
        "db-util",
        "db5.3-util",
        "libdb5.3",
        "libncurses6",
        "ncurses-base",
    ],
    # Takes the first package found: security updates should go first
    # If there was a security fix to a package before the stable release, this will find
    sources = [
        "@debian_buster_security//file:Packages.json",
        "@debian_buster//file:Packages.json",
    ],
)

# Java adoptopenjdk file, change the url for diffrent java installation
http_file(
    name = "adoptopenjdk",
    executable = True,
    sha256 = "47545884a5b4cc8becaa7338b53e0dabc6196fedea9bf8b30fa388985e35bcaf",
    urls = ["https://deepscan.jfrog.io/deepscan/distroless-generic/java/adoptopenjdk-11.0.11+9-linux.tar.gz"],
)

# PostgreSQL Client for MongoDB -> PostgreSQL migration
http_file(
    name = "postgresql-client",
    executable = True,
    sha256 = "18102fdccdd3c71e34f4d827e3f51fa3d694f55bf25c4c06af397aa241ecb15d",
    urls = ["https://deepscan.jfrog.io/deepscan/distroless-generic/postgresql/postgresql-9.5.2-1-linux-x64-binaries.tar.gz"],
)

http_file(
    name = "jq",
    executable = True,
    sha256 = "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44",
    urls = ["https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"],
)

http_file(
    name = "busybox",
    executable = True,
    sha256 = "87dffd21959238a0a088509123616f57420022db1a656870fae780e9b2a683cd",
    urls = ["https://deepscan.jfrog.io/deepscan/distroless-generic/busybox/1.32.1-glibc-busybox.tar.xz"],
)

#Added complied and slimed curl binary from source https://github.com/curl/curl/releases
http_file(
    name = "curl",
    executable = True,
    sha256 = "2d7237ec551fbe1a7ddaa8ede3aea5390fa354f6e2b45ccd65209e2d6c67290b",
    urls = ["https://deepscan.jfrog.io/deepscan/distroless-generic/curl/curl-7.74.0-linux.tar.gz"],
)
# Docker rules.
git_repository(
    name = "io_bazel_rules_docker",
    commit = "5eb0728594013d746959c4bd21aa4b0c3e3848d8",
    remote = "https://github.com/bazelbuild/rules_docker.git",
)

load(
    "@io_bazel_rules_docker//docker:docker.bzl",
    "docker_pull",
    "docker_repositories",
)

# Used to generate java ca certs.
docker_pull(
    name = "debian10",
    # From tag: 2020-11-18-130739
    digest = "sha256:5dd21a5ed0a9cd98c5d271dc8c7c11b2583d14071437c2ef86d0b25ab3070911",
    registry = "gcr.io",
    repository = "google-appengine/debian10",
)

docker_repositories()

# Have the py_image dependencies for testing.
load(
    "@io_bazel_rules_docker//python:image.bzl",
    _py_image_repos = "repositories",
)

_py_image_repos()

# Have the java_image dependencies for testing.
load(
    "@io_bazel_rules_docker//java:image.bzl",
    _java_image_repos = "repositories",
)

_java_image_repos()

# Have the go_image dependencies for testing.
load(
    "@io_bazel_rules_docker//go:image.bzl",
    _go_image_repos = "repositories",
)

_go_image_repos()
