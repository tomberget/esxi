variable "name" {
  type        = string
  default     = "grafana-operator"
  description = "Name of the helm release"
}

variable "namespace" {
  type        = string
  description = "It specify the grafana-operator namespace where the grafana-operator will deployed"
}

variable "chart_version" {
  type        = string
  description = "This will specify the grafana-operator chart version"
}

variable "ingress_host_name" {
  type        = string
  description = "This will specify the ingress url"
}
