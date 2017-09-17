variable source_ranges {
	type = "list"
	description = "Allowed IP addresses"
	default = ["0.0.0.0/0"]
}

variable ssh_rule_name {
	description = "SSH rule name"
	default = "default-allow-ssh"
}
