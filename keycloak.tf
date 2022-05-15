##################
# Keycloak
##################
module "keycloak" {
  count = var.keycloak_enabled ? 1 : 0

  source = "./modules/keycloak"

  namespace                  = kubernetes_namespace.keycloak.metadata.0.name
  chart_version              = var.keycloak_chart_version
  ingress_hostname           = "keycloak.${var.external_domain}"
  external_database_host     = format("%s-keycloak.%s", var.postgres_team, kubernetes_namespace.keycloak.metadata.0.name)
  external_database_username = data.kubernetes_secret.keycloak_db[count.index].data.username
  external_database_password = data.kubernetes_secret.keycloak_db[count.index].data.password
  ha_enabled                 = var.keycloak_ha_enabled

}

##################
# Keycloak External DB credentials
##################
data "kubernetes_secret" "keycloak_db" {
  count = var.keycloak_enabled ? 1 : 0

  metadata {
    name      = replace(format("bn_keycloak.%s-keycloak.credentials.postgresql.acid.zalan.do", var.postgres_team), "_", "-")
    namespace = kubernetes_namespace.keycloak.metadata.0.name
  }

  depends_on = [
    module.postgres_keycloak_db,
  ]
}
