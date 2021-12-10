# Local variables
variable "namespace" {
  description = "List of namespaces to create"
  type        = list(string)
  default = [
    "grafana",
  ]
}

variable "domain" {
  description = "Local domain to be used."
  type        = string
}

variable "external_domain" {
  description = "Proper domain to be used."
  type        = string
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

variable "metallb_ingress_nginx_ip_hostnum" {
  default = 3
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
  default     = false
}

variable "sonar_namespace" {
  description = "SonarQube namespace."
  type        = string
  default     = "sonar"
}

variable "sonar_enable_official" {
  description = "Use oteemo (false) or official (true)."
  type        = bool
  default     = true
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

variable "ha_metrics_token" {
  description = "Bearer token for the long lived token for Prometheus"
  type        = string
}

variable "access_key_id" {
  description = "AWS access key id uses for Route53 DNS administration"
  type        = string
}

variable "email_address" {
  description = "Email address used for issuing cert-manager certificates"
  type        = string
}

variable "region" {
  description = "AWS region used"
  type        = string
  default     = "eu-west-1"
}

variable "hosted_zone_id" {
  description = "Hosted zone id for Route53"
  type        = string
}
