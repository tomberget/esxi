variable "namespace" {}
variable "chart_version" {}
variable "chart_name" {}

variable "enable_host_network" {
  description = "Enable the host network discovery option"
}

variable "ha_metrics_token" {
  description = "Bearer token for the long lived token for Prometheus"
}

variable "app_name" {}
variable "domain" {}
