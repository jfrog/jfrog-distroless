package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_docker//docker:docker.bzl", "docker_build")
load("@package_bundle//file:packages.bzl", "packages")
load("//cacerts:java.bzl", "cacerts_java")
load("//locale:locale.bzl", "locale")
load("@io_bazel_rules_docker//java:image.bzl", "java_image")

cacerts_java(
    name = "cacerts_java",
)

locale(
    name = "locale",
    deb = packages["libc-bin"],
)

docker_build(
    name = "java-base",
    base = "//cc:debug",
    debs = [
        packages["libc6"],
        packages["zlib1g"],
        packages["libc-bin"],
        packages["net-tools"],
        packages["libprocps7"],
        packages["procps"],
        packages["libselinux1"],
        packages["libsystemd0"],
        packages["libpcre3"],
        packages["liblzma5"],
        packages["liblz4-1"],
        packages["libgcrypt20"],
        packages["libgpg-error0"],
        packages["libpng16-16"],
        packages["libfreetype6"],
        packages["fonts-dejavu-core"],
        packages["fontconfig-config"],
        packages["libexpat1"],
        packages["libfontconfig1"],
        packages["bash"],
        packages["dash"],
        packages["libtinfo6"],
        packages["libstdc++6"],
        packages["libgcc1"],
        packages["libncurses6"],
        packages["ncurses-base"],
        packages["ncurses-bin"],
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
    entrypoint = ["/bin/sh"],
    env = {
        "LANG": "C.UTF-8",
    },
    tars = [":cacerts_java",":locale",],
    symlinks = {
            "/usr/bin/awk": "/usr/bin/original-awk",
            "/usr/bin/vi": "/usr/bin/vim.tiny",
    },
)

docker_build(
    name = "java11",
    base = ":java-base",
    stamp = True,
    entrypoint = [
        "/usr/bin/java",
        "-jar",
        # We expect users to use:
        # cmd = ["/path/to/deploy.jar", "--option1", ...]
    ],
    symlinks = {
        "/usr/bin/java": "/java/jdk-11.0.11+9/bin/java",
    },
    tars = ["//experimental/adoptopenjdk:adoptopenjdk.tar"],
)

docker_build(
    name = "debug",
    base = ":java11",
    entrypoint = ["/bin/sh"],
     stamp = True,
     symlinks = {
             "/usr/bin/jar": "/java/jdk-11.0.11+9/bin/jar",
         }
)


load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")


container_test(
    name = "java11_test",
    configs = ["testdata/java.yaml"],
    image = ":java11",
)
java_image(
    name = "check_certs",
    srcs = ["testdata/CheckCerts.java"],
    base = "//java:java11",
    main_class = "testdata.CheckCerts",
)

container_test(
    name = "check_certs_test",
    configs = ["testdata/java.yaml"],
    image = ":java11",
)

container_test(
    name = "jar_test",
    configs = ["testdata/jar.yaml"],
    image = ":debug",
)

load("@io_bazel_rules_docker//container:container.bzl", "container_push")
container_push(
   name = "publish-base",
   image = ":java-base",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/java",
   tag =  "@BUILD_NUMBER@",
)
container_push(
   name = "publish",
   image = ":java11",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/java",
   tag =  "@BUILD_NUMBER@",
)

container_push(
   name = "publish-debug",
   image = ":debug",
   format = "Docker",
   registry = "docker.jfrog.io",
   repository = "jfrog/distroless/base/java",
   tag =  "@BUILD_NUMBER@-debug",
)
