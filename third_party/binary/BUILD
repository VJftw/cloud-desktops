
PACKER_VERSION = "1.8.0"

remote_file(
    name = "packer",
    url = f"https://releases.hashicorp.com/packer/{PACKER_VERSION}/packer_{PACKER_VERSION}_{CONFIG.OS}_{CONFIG.ARCH}.zip",
    extract = True,
    binary = True,
    hashes = [
        "94c5d65386fa8f17e36d3496fbbdf18d3bfab01306aa8000c14656b63070b7c2", # linux_amd64
    ],
    visibility = ["PUBLIC"],
)

JQ_VERSION = "1.6"

remote_file(
    name = "jq",
    out = "jq",
    url = f"https://github.com/stedolan/jq/releases/download/jq-{JQ_VERSION}/jq-{CONFIG.OS}64",
    binary = True,
    visibility = ["PUBLIC"],
    hashes = [
        "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44", # linux64
    ]
)
