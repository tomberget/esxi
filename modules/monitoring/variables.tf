variable "istio_enabled" {
  default = false
}

variable "grafana_org_name" {
  default = "ATARIfam"
}

variable "namespace" {}
variable "chart_version" {}

variable "prom_app_name" {}
variable "alrt_app_name" {}
variable "graf_app_name" {}
variable "domain" {}
