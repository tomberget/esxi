variable "namespace" {}

variable "chart_version" {}

variable "domain" {}

variable "chart_name" {}

variable "metallb_pihole_ip" {
  type = string
}

variable "enable_persistent_volume" {
  type    = bool
  default = true
}
