variable "namespace" {}
variable "chart_version" {}

variable "chart_name" {}

variable "metallb_ingress_nginx_ip" {
  type = string
}

variable "domain" {
  description = "Domain name used for the ingress."
  type        = string
}

variable "controller_replica" {
  description = "How many replicas to run of the ingress controller"
  type        = number
  default     = 1
}
