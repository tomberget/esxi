variable "namespace" {}
variable "chart_version" {}
variable "chart_name" {}

variable "enable_host_network" {
  description = "Enable the host network discovery option"
  type        = bool
  default     = false
}

variable "ha_metrics_token" {
  description = "Bearer token for the long lived token for Prometheus"
  type        = string
}

variable "app_name" {
  description = "Alternative name to use if chart name does not match the application good enough."
  type        = string
}
variable "domain" {
  description = "Domain to be used in order to resolve the ingress host"
  type        = string
}
