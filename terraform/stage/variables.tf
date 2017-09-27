variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable db_disk_image {
  description = "DB server disk image"
}

variable app_disk_image {
  description = "App server disk image"
}

variable app_instance_name {
  description = "App-server instance name"
}

variable app_instance_tags {
  type        = "list"
  description = "App-instance's tags array"
}

variable app_firewall_rule_name {
  description = "Firewall rule name for app-server"
}

variable app_firewall_t_tags {
  type        = "list"
  description = "Firewall target tags array for app-server"
}

variable app_address_ip_name {
  description = "Name of ip-address resource for app-server"
}

variable db_address_ip_name {
  description = "Name of ip-addres resource for db-server"
}

variable db_instance_name {
  description = "DB-server instance name"
}

variable db_instance_tags {
  type        = "list"
  description = "DB-instance's tags array"
}

variable db_firewall_rule_name {
  description = "Firewall rule name for db-server"
}

variable db_firewall_t_tags {
  type        = "list"
  description = "Firewall target tags array for db-server"
}

variable db_firewall_s_tags {
  type        = "list"
  description = "Firewall source tags array for db-server"
}

variable source_ranges {
  type = "list"
}

variable ssh_rule_name {
  description = "SSH rule name"
}
