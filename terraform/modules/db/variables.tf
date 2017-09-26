variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable db_disk_image {
  description = "DB server disk image"
  default     = "reddit-db-1505377831"
}

variable db_instance_name {
  description = "DB-server instance name"
  default = "reddit-db"
}

variable db_instance_tags{
  type = "list"
  description = "DB-instance's tags array"
  default = ["reddit-db"]
}

variable db_firewall_rule_name  {
  description = "Firewall rule name for db-server"
  default = "allow-mongo-default"
}

variable db_firewall_t_tags {
  type = "list"
  description = "Firewall target tags array for db-server"
  default = ["reddit-db"]
}

variable db_firewall_s_tags {
  type = "list"
  description = "Firewall source tags array for db-server"
  default = ["reddit-app"]
}

variable db_address_ip_name {
  description = "Name of ip-address resource for db-server"
  default = "reddit-db-ip"
}
