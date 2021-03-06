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
  default = 1
  type = number
}

# vSphere variables
variable "esxi_hosts" {
  default = ["esxi"]
}

variable "datacenter_name" {
  type = string
}

variable "datastore_name" {
  type = string
}
