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
  type    = number
}

variable "metallb_traefik_ip_hostnum" {
  default = 2
  type    = number
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

# Enable features

#
variable "namespaces" {
  description = "List of all namespaces in use"
  type = list(string)
  default = [
    "default",
    "home-assistant",
    "kube-system",
    "metallb",
    "monitoring",
    "node-red",
    "pihole",
    "traefik",
  ]
}
