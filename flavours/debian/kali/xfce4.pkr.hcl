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

source "googlecompute" "kali" {
  disable_default_service_account = true
  disk_type                       = "pd-ssd"
  image_name                      = "kali-xfce4-${var.version_suffix}"
  machine_type                    = "e2-standard-4"
  metadata = {
    enable-oslogin = "false"
  }
  disk_size = 50
  network             = "packer"
  omit_external_ip    = true
  preemptible         = true
  project_id          = "${var.gcp_project_id}"
  source_image_family = "debian-11"
  image_family = "kali"
  ssh_username        = "packer"
  subnetwork          = "private"
  use_iap             = true
  use_internal_ip     = true
  zone                = "europe-west1-d"
}

build {
  sources = ["sources.googlecompute.kali"]

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = "//flavours/debian:_chrome-remote-desktop"
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = ":_debian-to-kali"
  }

  post-processor "manifest" {
      strip_path = true
  }

}
