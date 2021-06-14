variable "namespace" {}
variable "chart_version" {}
variable "domain" {}
variable "chart_name" {}
variable "metallb_unifi_gui_ip" {
  type = string
}
variable "metallb_unifi_controller_ip" {
  type = string
}
variable "metallb_unifi_discovery_ip" {
  type = string
}
variable "metallb_unifi_stun_ip" {
  type = string
}
