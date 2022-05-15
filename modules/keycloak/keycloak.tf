resource "helm_release" "keycloak" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = var.name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/keycloak_values.yaml", {
      ingress_hostname           = var.ingress_hostname
      external_database_host     = var.external_database_host
      external_database_username = var.external_database_username
      external_database_password = var.external_database_password
      ha_enabled                 = var.ha_enabled
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
