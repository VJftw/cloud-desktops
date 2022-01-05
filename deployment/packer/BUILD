subinclude("//build/defs:terraform")

terraform_root(
    name = "packer",
    srcs = [
        "main.tf",
        "nat.tf",
        "outputs.tf",
        "vpc.tf",
    ],
    modules = [
        "@third_party/repo/org-infra//modules/account/gcp:gcp",
    ],
    pull_request_state_bucket = "vjp-sandbox-terraform-state",
)
