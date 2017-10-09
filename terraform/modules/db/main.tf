resource "google_compute_instance" "db" {
  name         = "${var.db_instance_name}"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  tags         = "${var.db_instance_tags}"

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      #nat_ip = "${google_compute_address.db_ip.address}"
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

resource "google_compute_firewall" "firewall_mongo" {
  name    = "${var.db_firewall_rule_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  target_tags = "${var.db_firewall_t_tags}"
  source_tags = "${var.db_firewall_s_tags}"
}

#resource "google_compute_address" "db_ip"{
#  name = "${var.db_address_ip_name}"
#}
