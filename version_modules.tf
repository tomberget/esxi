variable "cert_manager_chart_version" {
  default = "1.8.0"
}

variable "cilium_chart_version" {
  default = "1.11.4"
}

variable "home_assistant_chart_version" {
  default = "13.0.2"
}

variable "mealie_chart_version" {
  default = "5.0.1"
}

variable "grafana_operator_chart_version" {
  default = "1.5.3"
}

variable "ingress_nginx_chart_version" {
  default = "4.1.0"
}

variable "keycloak_chart_version" {
  default = "8.0.2"
}

variable "kube_prometheus_stack_versions" {
  default = {
    chart    = "35.0.3"
    operator = "0.56.0"
  }
}

variable "kured_chart_version" {
  default = "2.13.0"
}

variable "metallb_chart_version" {
  default = "3.0.1"
}

variable "node_red_chart_version" {
  default = "10.0.0"
}

variable "pihole_chart_version" {
  default = "2.5.8"
}

variable "postgres_operator_chart_version" {
  default = "1.8.0"
}
