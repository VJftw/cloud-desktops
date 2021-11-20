
PACKER_VERSION = "1.7.8"

remote_file(
    name = "packer",
    url = f"https://releases.hashicorp.com/packer/{PACKER_VERSION}/packer_{PACKER_VERSION}_{CONFIG.OS}_{CONFIG.ARCH}.zip",
    extract = True,
    binary = True,
    hashes = [
        "8a94b84542d21b8785847f4cccc8a6da4c7be5e16d4b1a2d0a5f7ec5532faec0", # linux_amd64
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
