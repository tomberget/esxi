# Operator
variable "name" {
  description = "The name of the Postgres-Operator"
  type        = string
  default     = "postgres-operator"
}

variable "namespace" {
  description = "The namespace where the Postgres-Operator will be deployed to."
  type        = string
}

variable "operator_chart_version" {
  description = "The Postgres-Operator Helm chart version."
  type        = string
  default     = "v1.7.1"
}

# UI
variable "ui_chart_version" {
  description = "The Postgres-Operator UI Helm chart version."
  type        = string
  default     = "v1.7.0"
}

variable "ui_ingress_host" {
  description = "Host name of the ingress, when empty ingress is disabled"
  type        = string
  default     = ""
}

variable "teams" {
  description = "ATARIFAM teams"
  type        = list(string)
  default     = ["athome"]
}
