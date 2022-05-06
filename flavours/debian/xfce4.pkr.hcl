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

source "googlecompute" "debian" {
  disable_default_service_account = true
  disk_type                       = "pd-ssd"
  image_name                      = "debian-xfce4-${var.version_suffix}"
  machine_type                    = "e2-medium"
  metadata = {
    enable-oslogin = "false"
  }
  network             = "packer"
  omit_external_ip    = true
  preemptible         = true
  project_id          = "${var.gcp_project_id}"
  source_image_family = "debian-11"
  image_family = "debian"
  ssh_username        = "packer"
  subnetwork          = "private"
  use_iap             = true
  use_internal_ip     = true
  zone                = "europe-west1-d"
}

build {
  sources = ["sources.googlecompute.debian"]

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = ":_chrome-remote-desktop"
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = ":_xfce4"
  }

  post-processor "manifest" {
      output = "manifest.json"
      strip_path = true
  }

}
