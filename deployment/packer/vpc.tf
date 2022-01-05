resource "google_compute_network" "packer" {
  project = local.project_id

  name                            = "packer"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

locals {
  region = "europe-west1"
  subnetworks = {
    "public" = {
      "cidr_block"               = "10.0.1.0/24"
      "private_ip_google_access" = true
    },
    "private" = {
      "cidr_block"               = "10.0.8.0/21"
      "private_ip_google_access" = true
    },
  }
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each = local.subnetworks

  project = local.project_id

  name          = each.key
  ip_cidr_range = each.value["cidr_block"]
  region        = local.region
  network       = google_compute_network.packer.id

  private_ip_google_access = lookup(each.value, "private_ip_google_access", false)
}

resource "google_compute_firewall" "default_deny_egress" {
  project = local.project_id

  name      = "default-deny-egress"
  network   = google_compute_network.packer.name
  direction = "EGRESS"

  priority = 65535 # lowest priority

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default_deny_ingress" {
  project = local.project_id

  name      = "default-deny-ingress"
  network   = google_compute_network.packer.name
  direction = "INGRESS"

  priority = 65535 # lowest priority

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "bastion_iap_ssh" {
  project = local.project_id

  name    = "allow-ssh-over-iap"
  network = google_compute_network.packer.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}
