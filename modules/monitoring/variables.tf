variable "grafana_org_name" {
  default = "ATARIfam"
}

variable "namespace" {}
variable "chart_version" {}

variable "domain" {}

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
