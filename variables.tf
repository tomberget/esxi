# Local variables
variable "domain" {
  type    = string
  default = "atarifam.lan"
}

variable "metallb_network_range" {
  type = string
}

# MetalLB variables
variable "metallb_pihole_ip_hostnum" {
  type = number
}

# Unifi variables
variable "metallb_unifi_gui_ip_hostnum" {
  type = number
}

variable "metallb_unifi_controller_ip_hostnum" {
  type = number
}

variable "metallb_unifi_discovery_ip_hostnum" {
  type = number
}

variable "metallb_unifi_stun_ip_hostnum" {
  type = number
}

# vSphere variables
variable "esxi_hosts" {}

variable "datacenter_name" {
  type = string
}

variable "datastore_name" {
  type = string
}

variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
}
