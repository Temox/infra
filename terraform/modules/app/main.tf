resource "google_compute_instance" "app" {
  name         = "${var.app_instance_name}"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  tags         = "${var.app_instance_tags}"

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "${var.app_firewall_rule_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = "${var.app_firewall_t_tags}"
}

resource "google_compute_address" "app_ip" {
  name = "${var.app_address_ip_name}"
}
