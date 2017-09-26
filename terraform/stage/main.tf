provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = "${var.source_ranges}"
  ssh_rule_name = "${var.ssh_rule_name}"
}

module "app" {
  source                 = "../modules/app"
  public_key_path        = "${var.public_key_path}"
  app_disk_image         = "${var.app_disk_image}"
  app_instance_name      = "${var.app_instance_name}"
  app_instance_tags      = "${var.app_instance_tags}"
  app_firewall_rule_name = "${var.app_firewall_rule_name}"
  app_firewall_t_tags    = "${var.app_firewall_t_tags}"
  app_address_ip_name    = "${var.app_address_ip_name}"
}

module "db" {
  source                = "../modules/db"
  public_key_path       = "${var.public_key_path}"
  db_disk_image         = "${var.db_disk_image}"
  db_instance_name      = "${var.db_instance_name}"
  db_instance_tags      = "${var.db_instance_tags}"
  db_firewall_rule_name = "${var.db_firewall_rule_name}"
  db_firewall_t_tags    = "${var.db_firewall_t_tags}"
  db_firewall_s_tags    = "${var.db_firewall_s_tags}"
}
