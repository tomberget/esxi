variable "namespace" {}
variable "chart_version" {}
variable "chart_name" {}

variable "domain" {
  description = "Domain to be used in order to resolve the ingress host"
  type        = string
}
