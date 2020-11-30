provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone 
}

// Private VPC
resource "google_compute_network" "main" {
  name = "iap-test-network"

  delete_default_routes_on_create = true
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.main.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"] // Add 3389 for RDP
  }

  source_ranges = [ "35.235.240.0/20" ] // Googles IAP ips
}

resource "google_compute_instance" "iap_test" {
  name         = "iap-test"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.main.name
    // Note: No external IP is defined
  }
}

resource "google_project_iam_binding" "iap_access" {
  project = var.project
  role    = "roles/iap.tunnelResourceAccessor"

  members = var.members
}
