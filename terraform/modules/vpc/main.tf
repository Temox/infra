resource "google_compute_firewall" "firewall_ssh" {
  name        = "${var.ssh_rule_name}"
  network     = "default"
  description = "allow ssh"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = "${var.source_ranges}"
}
