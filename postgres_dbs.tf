# Keycloak PostgreSQL Database
module "postgres_keycloak_db" {
  source = "./modules/postgres_db"

  name       = "keycloak"
  namespace  = kubernetes_namespace.keycloak.metadata.0.name
  users      = { "bn_keycloak" : [] }
  databases  = { "bitnami_keycloak" : "bn_keycloak" }
  instances  = 1
  nfs_server = var.nfs_server

  depends_on = [
    module.postgres_operator,
  ]
}
