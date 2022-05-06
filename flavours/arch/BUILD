subinclude("//build/defs:packer")

packer_image(
    name = "xfce4",
    template = "xfce4.pkr.hcl",
    deps = [
        ":_base",
        ":_xfce4",
        ":_chrome-remote-desktop",
    ],
    dynamic_vars = {
        "version_suffix": "//build:version",
    },
    vars = {
        "gcp_project_id": "$GCP_PROJECT_ID",
    },
)

export_file(
    name = "_chrome-remote-desktop",
    src = "chrome-remote-desktop.sh",
    visibility = ["//flavours/arch/..."],
)

export_file(
    name = "_xfce4",
    src = "xfce4.sh",
)

export_file(
    name = "_base",
    src = "base.sh",
    visibility = ["//flavours/arch/..."],
)
