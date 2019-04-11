package(default_visibility = ["//visibility:public"])
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

genrule(
    name = "jq_tar",
    srcs = ["@jq//file:downloaded"],
    outs = ["jq.tar"],
    cmd = "mkdir jq; cp $(<) jq/jq-linux64; \
            tar -cf $@ jq",
)


