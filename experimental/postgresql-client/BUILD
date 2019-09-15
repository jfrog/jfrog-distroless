package(default_visibility = ["//visibility:public"])
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

genrule(
    name = "postgresql-client_tar",
    srcs = ["@postgresql-client//file:downloaded"],
    outs = ["postgresql-client.tar"],
    cmd = "mkdir postgresql-client; \
           tar xzf $(<) -C postgresql-client --strip-components=1; \
           tar -cf $@ postgresql-client;",
)