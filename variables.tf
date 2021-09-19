# Local variables
variable "domain" {
  type    = string
  default = "atarifam.lan"
}

variable "metallb_network_range" {
  type = string
}

# MetalLB variables
variable "metallb_pihole_ip_hostnum" {
  default = 1
  type    = number
}

variable "metallb_traefik_ip_hostnum" {
  default = 2
  type    = number
}

# vSphere variables
variable "esxi_hosts" {
  default = ["esxi"]
}

variable "datacenter_name" {
  type = string
}

variable "datastore_name" {
  type = string
}

# Sonarqube
variable "sonar_enabled" {
  description = "Enable or disable the SonarQube module"
  type        = bool
  default     = true
}

variable "sonar_namespace" {
  description = "SonarQube namespace."
  type        = string
  default     = "sonar"
}

variable "sonar_enable_official" {
  description = "Use oteemo (false) or official (true)."
  type        = bool
  default     = false
}

variable "sonar_helm_chart" {
  description = "Helm chart settings for sonar"
  type        = map(map(string))
  default = {
    oteemo = {
      chart_repository = "https://oteemo.github.io/charts"
      chart_version    = "9.6.5"
      image_tag        = "8.9.2-community"
      official         = "false"
    },
    official = {
      chart_repository = "https://SonarSource.github.io/helm-chart-sonarqube"
      chart_version    = "1.1.3+107"
      image_tag        = "9.0.1-community"
      official         = "true"
    },
  }

}

variable "sonar_chart_repository" {
  description = "The chart repository used for SonarQube."
  type        = string
  default     = "https://oteemo.github.io/charts"
}

variable "sonar_chart_version" {
  description = "The Helm chart version used for sonar."
  type        = string
  default     = "9.6.5"
}

variable "sonar_image_tag" {
  description = "Set the SonarQube image tag. Must be overridden in TFvars, as the default is always a -community image."
  type        = string
  default     = "8.9.2-community"
}

variable "sonar_ldap_bind_password" {
  description = "The Encrypted LDAP Bind password created by SonarQube. Can be set only after it has been created in SonarQube."
  type        = string
  default     = ""
}

variable "sonar_ingress_host" {
  description = "The ingress host where sonar will be made available."
  type        = string
  default     = "sonar.atarifam.lan"
}
