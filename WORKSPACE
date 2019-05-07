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
    name = "debian_stretch",
    arch = "amd64",
    distro = "stretch",
    sha256 = "79a66cd92ba9096fce679e15d0b5feb9effcf618b0a6d065eb32684dbffd0311",
    snapshot = "20190224T095432Z",
    url = "https://deepscan.jfrog.io/deepscan/snapshot.debian.org/archive",
)

dpkg_src(
    name = "debian_stretch_backports",
    arch = "amd64",
    distro = "stretch-backports",
    sha256 = "521da2a9eb91afccfb008272a05c7e8e2fde1d1d54f46a1d356b7be88920fffe",
    snapshot = "20190217T090420Z",
    url = "https://deepscan.jfrog.io/deepscan/snapshot.debian.org/archive",
)

dpkg_src(
    name = "debian_stretch_security",
    package_prefix = "https://deepscan.jfrog.io/deepscan/snapshot.debian.org/archive/debian-security/20190131T235445Z/",
    packages_gz_url = "https://deepscan.jfrog.io/deepscan/snapshot.debian.org/archive/debian-security/20190131T235445Z/dists/stretch/updates/main/binary-amd64/Packages.gz",
    sha256 = "4108944dd44b1b0d57c4765115244d363c1d69285c1d574ad61bb51f6d81828f",
)

dpkg_src(
    name = "debian_stretch_local",
    package_prefix = "https://deepscan.jfrog.io/deepscan/debian-local/",
    packages_gz_url = "https://deepscan.jfrog.io/deepscan/debian-local/dists/stretch/main/binary-amd64/Packages.gz",
    sha256 = "c33c898bcd3573a64169982d1270a07aee6a01996cf22e82ba0cca13251a8418",
)

dpkg_list(
    name = "package_bundle",
    packages = [
        # Version required to skip a security fix to the pre-release library
        # TODO: Remove when there is a security fix or dpkg_list finds the recent version
        "libc6",
        "base-files",
        "ca-certificates",
#        "openssl=1.1.1a-1",
        "openssl",
        "libssl1.1",
        "libtinfo5",
        "netbase",
        "tzdata",
        "bash",
        "dash",
        "net-tools",
        "procps=2:3.3.15-2",
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
        "libgcrypt20=1.8.4-5",
        "libgpg-error0",
        "libpng16-16",
        "libfreetype6",
        "fonts-dejavu-core",
        "fontconfig-config",
        "libfontconfig1",
        "libexpat1",
    ],
    # Takes the first package found: security updates should go first
    # If there was a security fix to a package before the stable release, this will find
    # the older security release. This happened for stretch libc6.
    sources = [
        "@debian_stretch_security//file:Packages.json",
        "@debian_stretch_backports//file:Packages.json",
        "@debian_stretch//file:Packages.json",
        "@debian_stretch_local//file:Packages.json",
    ],
)

# Java adoptopenjdk file, change the url for diffrent java installation

http_file(
    name = "adoptopenjdk",
    executable = True,
    sha256 = "d02089d834f7702ac1a9776d8d0d13ee174d0656cf036c6b68b9ffb71a6f610e",
    urls = ["https://deepscan.jfrog.io/deepscan/distroless-generic/java/OpenJDK11U-jdk_x64_linux_hotspot_11.0.2_9.tar.gz"],
)

http_file(
    name = "jq",
    executable = True,
    sha256 = "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44",
    urls = ["https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"],
)

#http_file(
#    name = "busybox",
#    executable = True,
#    sha256 = "5776b1f4fbff641eb09024483fde28467e81bc74118c0c65ce5a8ad7a1029063",
#    urls = ["https://busybox.net/downloads/binaries/1.30.0-i686/busybox"],
#)
#use this fixed version for this issue https://github.com/GoogleContainerTools/distroless/issues/225
http_file(
    name = "busybox",
    executable = True,
    sha256 = "af052caf38fe81eae321005c5c151650d64714bbe0a3f5e1f7cb39ba179cf7d6",
    urls = ["https://deepscan.jfrog.io/deepscan/distroless-generic/busybox/1.30.0-glibc-busybox.tar.xz"],
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
    name = "debian9",
    # From tag: 2019-02-27-130449
    digest = "sha256:fd26dfa474b76ef931e439537daba90bbd90d6c5bbdd0252616e6d87251cd9cd",
    registry = "gcr.io",
    repository = "google-appengine/debian9",
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
