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

variable "region" {
  description = "AWS region"
  type        = string
}

variable "access_key_id" {
  description = "AWS access key id used for Route53 DNS administration"
  type        = string
}

variable "email_address" {
  description = "Email address used for issuing cert-manager certificates"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted zone id for Route53"
  type        = string
}
