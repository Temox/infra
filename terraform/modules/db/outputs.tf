output "db_internal_ip" {
  value = "${google_compute_instance.db.network_interface.0.address.0.nat_ip}"
}
