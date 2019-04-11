package(default_visibility = ["//base:__subpackages__"])

load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")
load(":commands.bzl", "BUSYBOX_COMMANDS")


genrule(
    name = "busybox_tar",
    srcs = ["@busybox//file:downloaded"],
    outs = ["busybox.tar"],
    cmd = "mkdir -p busybox/tmp; cp $(<) busybox/tmp/busybox; cd busybox/tmp; \
           tar -xf busybox; cd ../; \
           mv tmp/bin/* .; \
           rm -rf tmp; \
           cd ..; \
           tar -cf $@ busybox",
)