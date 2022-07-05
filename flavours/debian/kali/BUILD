subinclude("//build/defs:packer")

packer_image(
    name = "xfce4",
    template = "xfce4.pkr.hcl",
    deps = [
        "//flavours/debian:_chrome-remote-desktop",
        ":_debian-to-kali",
    ],
    dynamic_vars = {
        "version_suffix": "//build:version",
    },
    vars = {
        "gcp_project_id": "$GCP_PROJECT_ID",
    },
)

export_file(
    name = "_debian-to-kali",
    src = "debian-to-kali.sh",
)
