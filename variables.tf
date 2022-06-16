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

variable "nfs_server" {
  description = "NFS server to mount the persistent volume"
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

# Keycloak variables
variable "keycloak_enabled" {
  default = true
}

variable "keycloak_external_database_enabled" {
  default = true
}

variable "postgres_team" {
  description = "Postgres team name"
  type        = string
  default     = "athome"
}

variable "keycloak_ha_enabled" {
  description = "Killswitch to enable or disable high availability for keycloak"
  type        = bool
  default     = true
}

# Keycloak external postgres database
variable "keycloak_postgres_enabled" {
  default = true
}
