variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "App server disk image"
  default     = "reddit-app-1505378085"
}

variable app_instance_name {
  description = "App-server instance name"
  default = "reddit-app"
}

variable app_instance_tags{
  type = "list"
  description = "App-instance's tags array"
  default = ["reddit-app"]
}

variable app_firewall_rule_name  {
  description = "Firewall rule name for app-server"
  default = "allow-puma-default"
}

variable app_firewall_t_tags {
  type = "list"
  description = "Firewall target tags array for app-server"
  default = ["reddit-app"]
}

variable app_address_ip_name {
  description = "Name of ip-adress resource for app-server"
  default = "reddit-app-ip"
}

