provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

// Private VPC
resource "google_compute_network" "main" {
  name = "iap-test-network"

  // delete_default_routes_on_create = true
}

// Cloud NAT
resource "google_compute_router" "main" {
  name    = "iap-test-router"
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.main.name
  region                             = google_compute_router.main.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

// IAP Firewall Rule
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.main.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"] // Add 3389 for RDP
  }

  source_ranges = ["35.235.240.0/20"] // Googles IAP ips
}

// Compute Instance
resource "google_compute_instance" "iap_test" {
  name         = "iap-test"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-dev"
    }
  }

  network_interface {
    network = google_compute_network.main.name
    // Note: No external IP is defined
  }
}

// IAM Binding
resource "google_project_iam_binding" "iap_access" {
  project = var.project
  role    = "roles/iap.tunnelResourceAccessor"

  members = var.members
}
