package(default_visibility = ["//base:__subpackages__"])
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

genrule(
    name = "curl_tar",
    srcs = ["@curl//file:downloaded"],
    outs = ["curl.tar"],
    cmd = "mkdir curl; tar xjf $(<) -C curl --strip-components=1; \
           mv curl/curl.ermine curl/curl; \
           tar -cf $@ curl",
)



