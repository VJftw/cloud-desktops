sh_binary(
    name = "version",
    main = "version.sh",
    visibility = ["PUBLIC"],
)

sh_binary(
    name = "release_body",
    main = "release_body.sh",
    deps = [
        "//third_party/binary:jq",
    ],
    visibility = ["PUBLIC"],
)

sh_binary(
    name = "publicise",
    main = "publicise.sh",
    deps = [
        "//third_party/binary:jq",
    ],
    visibility = ["PUBLIC"],
)

sh_binary(
    name = "cleanup",
    main = "cleanup.sh",
    deps = [
        "//third_party/binary:jq",
    ],
    visibility = ["PUBLIC"],
)

sh_binary(
    name = "release_readme",
    main = "release_readme.sh",
    deps = [
        "//third_party/binary:jq",
    ],
    visibility = ["PUBLIC"],
)
