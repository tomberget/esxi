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

variable "grafana_ingress_host" {
  type        = string
  description = "This will specify the ingress url"
}

variable "grafana_data_source_url" {
  type        = string
  description = "This will specify prometheus datasource url for prod"
}

variable "grafana_data_source_url_alertmanager" {
  description = "This will specify the Alertmanager datasource url for prod"
  type        = string
}

variable "grafana_data_source_access" {
  type        = string
  description = "This will specify prometheus datasource url"
}

variable "grafana_labels" {
  description = "Add labels to service, pod and ingress."
  type        = map(string)
}
