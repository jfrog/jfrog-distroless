package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//docker:docker.bzl", "docker_build")
load("@package_bundle//file:packages.bzl", "packages")

# An intermediate image for Java and other "mostly statically" compiled languages
[docker_build(
    name = "cc" if (not mode) else mode[1:],
    base = "//base" + mode,
    debs = [
        packages["base-files"],
        packages["netbase"],
        packages["tzdata"],
        packages["libc6"],
        packages["libc-bin"],
        packages["libtinfo6"],
        packages["libncurses6"],
        packages["libncursesw6"],
        packages["ncurses-base"],
        packages["ncurses-bin"],
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
        packages["libgcc1"],
        packages["libgomp1"],
        packages["libstdc++6"],
        packages["libpcre3"],
        packages["libbz2-1.0"],
        packages["libattr1"],
        packages["libacl1"],
        packages["hostname"],
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
    },
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