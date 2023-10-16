PACKER_VERSION = "1.9.4"

remote_file(
    name = "packer",
    binary = True,
    extract = True,
    hashes = [
        "6cd5269c4245aa8c99e551d1b862460d63fe711c58bec618fade25f8492e80d9",  # linux_amd64
    ],
    url = f"https://releases.hashicorp.com/packer/{PACKER_VERSION}/packer_{PACKER_VERSION}_{CONFIG.OS}_{CONFIG.ARCH}.zip",
    visibility = ["PUBLIC"],
)

JQ_VERSION = "1.6"

remote_file(
    name = "jq",
    out = "jq",
    binary = True,
    hashes = [
        "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44",  # linux64
    ],
    url = f"https://github.com/stedolan/jq/releases/download/jq-{JQ_VERSION}/jq-{CONFIG.OS}64",
    visibility = ["PUBLIC"],
)
