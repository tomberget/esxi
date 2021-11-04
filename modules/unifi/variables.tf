variable "namespace" {
  description = "Namespace that should be used or created"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
}

variable "domain" {
  description = "Domain that should be used"
  type        = string
}

variable "chart_name" {
  description = "Name of the Helm chart"
  type        = string
}
