variable "grafana_org_name" {
  default = "ATARIfam"
}

variable "namespace" {
  default     = "monitoring"
  type        = string
  description = "Namespace to deploy the prometheus stack"
}
variable "chart_version" {
  type        = string
  description = "Chart version for the Prometheus stack"
}

variable "domain" {
  type = string
}

variable "operator_version" {
  type        = string
  description = "Operator version for the Prometheus stack"
}

variable "ingress_route_list" {
  description = "IngressRoute hostname and service for kube-prom-stack"
  type        = map(any)
  default = {
    "prometheus" = {
      "service_name" = "prometheus-operator-kube-p-prometheus",
      "port_name"    = "web",
    },
    "alertmanager" = {
      "service_name" = "prometheus-operator-kube-p-alertmanager",
      "port_name"    = "web",
    },
    "grafana" = {
      "service_name" = "prometheus-operator-grafana",
      "port_name"    = "service",
    },
  }
}
