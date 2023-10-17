packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "gcp_project_id" {
  type    = string
  default = ""
}

variable "version_suffix" {
  type    = string
  default = ""
}

source "googlecompute" "arch" {
  disable_default_service_account = true
  disk_type                       = "pd-ssd"
  image_name                      = "arch-xfce4-${var.version_suffix}"

  // 2023-10-13 - Pricing
  // c3-standard-4 (cpu quota limit: 8): $0.091864 (spot)
  // e2-standard-4 (cpu quota limit: 8): $0.0555 (spot)
  // e2-standard-4                     : $0.044216 (spot)
  machine_type                    = "e2-standard-8"
  metadata = {
    enable-oslogin = "false"
  }
  network             = "packer"
  omit_external_ip    = true
  preemptible         = true
  project_id          = "${var.gcp_project_id}"
  source_image_project_id = ["arch-linux-gce"]
  source_image_family = "arch"
  image_family = "arch"
  ssh_username        = "packer"
  subnetwork          = "private"
  use_iap             = true
  use_internal_ip     = true
  zone                = "europe-west1-d"
}

build {
  sources = ["sources.googlecompute.arch"]

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = ":_base"
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = ":_chrome-remote-desktop"
  }

  provisioner "shell" {
    inline = [
<<EOF
mkdir -p /etc/profile.d
cat <<EOT | base64 -d | sudo tee /etc/profile.d/configure-chrome-remote-desktop.sh
${base64encode(file(":_configure-chrome-remote-desktop"))}
EOT
sudo chmod +x /etc/profile.d/configure-chrome-remote-desktop.sh
EOF
    ]
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = ":_xfce4"
  }

  post-processor "manifest" {
      strip_path = true
  }

}
