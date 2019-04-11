package(default_visibility = ["//visibility:public"])
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

# For convenience, rename busybox-x86_64 to busybox.
genrule(
    name = "adoptopenjdk_tar",
    srcs = ["@adoptopenjdk//file:downloaded"],
    outs = ["adoptopenjdk.tar"],
    cmd = "mkdir java; cp $(<) java/adoptopenjdk; cd java; \
        tar -xf adoptopenjdk; \
        rm adoptopenjdk; cd ../; \
        tar -cf $@ java",
)
