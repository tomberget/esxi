resource "helm_release" "keycloak" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = var.name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/keycloak_values.yaml", {
      replica_count              = local.replica_count
      ingress_hostname           = var.ingress_hostname
      external_database_host     = var.external_database_host
      external_database_username = var.external_database_username
      external_database_password = var.external_database_password
      ha_enabled                 = var.ha_enabled
      kc_hostname                = var.ingress_hostname
      kc_cache_type              = local.kc_cache_type
      kc_cache_stack             = local.kc_cache_stack
      java_opts_append           = local.java_opts_append
    }),
  ]

  set_sensitive {
    name  = "auth.adminPassword"
    value = random_password.admin_password.result
  }

  set_sensitive {
    name  = "auth.managementPassword"
    value = random_password.management_password.result
  }
}

# Locals for HA setup
locals {
  replica_count    = var.ha_enabled ? 2 : 1
  kc_cache_type    = var.ha_enabled ? "ispn" : "local"
  kc_cache_stack   = var.ha_enabled ? "kubernetes" : "udp"
  java_opts_append = var.ha_enabled ? format("-Djgroups.dns.query=%s-headless.%s", var.name, var.namespace) : ""
}

# Create passwords
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "management_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
