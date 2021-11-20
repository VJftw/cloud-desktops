subinclude("//build/defs:packer")

packer_image(
    name = "xfce4",
    template = "xfce4.json",
    deps = [
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
    visibility = ["//flavours/debian/..."],
)

export_file(
    name = "_xfce4",
    src = "xfce4.sh",
)
