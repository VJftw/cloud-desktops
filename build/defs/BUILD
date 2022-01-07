export_file(
    name = "packer",
    src = "packer.build_defs",
    visibility = ["PUBLIC"],
)

genrule(
    name = "terraform",
    srcs = [
        "@third_party/repo/org-infra//build/defs:terraform",
    ],
    outs = ["terraform.build_defs"],
    cmd = """
cp $SRCS $OUTS
sed -i 's#//#@third_party/repo/org-infra//#g' $OUTS
    """,
    visibility = ["PUBLIC"],
)
