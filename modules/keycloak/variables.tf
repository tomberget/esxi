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

variable "chart_repository" {
  type        = string
  description = "It specifies the chart repository of grafana-operator chart"
}

variable "keycloak_ingress_host" {
  type        = string
  description = "This will specify the ingress url"
}
