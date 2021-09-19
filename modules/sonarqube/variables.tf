variable "sonar_enabled" {
  description = "Enable or disable the SonarQube module"
  type        = bool
  default     = false
}

variable "sonar_namespace" {
  description = "SonarQube namespace."
  type        = string
  default     = "sonar"
}

variable "sonar_chart_repository" {
  description = "The chart repository used for SonarQube."
  type        = string
}

variable "sonar_chart_version" {
  description = "The Helm chart version used for sonar."
  type        = string
  default     = "9.8.0"
}

variable "sonar_image_tag" {
  description = "Set the SonarQube image tag. Must be overridden in TFvars, as the default is always a -community image."
  type        = string
}

variable "sonar_ldap_bind_password" {
  description = "The Encrypted LDAP Bind password created by SonarQube. Can be set only after it has been created in SonarQube."
  type        = string
  default     = ""
}

variable "sonar_ingress_host" {
  description = "The ingress host where sonar will be made available."
  type        = string
}

variable "sonar_reference_key" {
  description = "The variable reference key from the Helm chart variable."
  type        = string
}
