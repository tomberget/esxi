data "kubernetes_all_namespaces" "all_namespaces" {}

module "cilium" {
  source = "./modules/cilium"

  chart_name    = "cilium"
  chart_version = var.cilium_chart_version
  namespace     = "kube-system"

  domain = var.external_domain
}

module "metallb" {
  source = "./modules/metallb"

  chart_name    = "metallb"
  chart_version = var.metallb_chart_version
  namespace     = kubernetes_namespace.metallb.metadata.0.name

  network_range = var.metallb_network_range

  depends_on = [
    module.cilium
  ]
}

module "monitoring" {
  source = "./modules/monitoring"

  chart_version    = lookup(var.kube_prometheus_stack_versions, "chart", "")
  operator_version = lookup(var.kube_prometheus_stack_versions, "operator", "")
  namespace        = kubernetes_namespace.monitoring.metadata.0.name

  domain = var.external_domain

  depends_on = [
    module.ingress_nginx,
    module.persistent_volume["alertmanager"],
    module.persistent_volume["prometheus"],
    module.persistent_volume["grafana"],
  ]
}

module "home_assistant" {
  source = "./modules/home_assistant"

  chart_version = var.home_assistant_chart_version
  namespace     = kubernetes_namespace.home_assistant.metadata.0.name
  chart_name    = "home-assistant"

  enable_host_network = true
  ha_metrics_token    = var.ha_metrics_token

  app_name = "ha"
  domain   = var.external_domain

  depends_on = [
    module.monitoring,
    module.persistent_volume["home-assistant"],
  ]
}

module "node_red" {
  source = "./modules/node_red"

  chart_name    = "node-red"
  chart_version = var.node_red_chart_version
  namespace     = kubernetes_namespace.home_assistant.metadata.0.name
  domain        = var.external_domain

  depends_on = [
    module.home_assistant,
    module.persistent_volume["node-red"],
  ]
}

module "ingress_nginx" {
  source = "./modules/ingress_nginx"

  chart_name               = "ingress-nginx"
  chart_version            = var.ingress_nginx_chart_version
  namespace                = kubernetes_namespace.nginx.metadata.0.name
  metallb_ingress_nginx_ip = cidrhost(var.metallb_network_range, var.metallb_ingress_nginx_ip_hostnum)
  domain                   = var.external_domain
  controller_replica       = 3

  depends_on = [
    module.metallb
  ]
}

module "pihole" {
  source = "./modules/pihole"

  chart_name        = "pihole"
  chart_version     = var.pihole_chart_version
  namespace         = kubernetes_namespace.pihole.metadata.0.name
  domain            = var.external_domain
  metallb_pihole_ip = cidrhost(var.metallb_network_range, var.metallb_pihole_ip_hostnum)

  depends_on = [
    module.ingress_nginx,
    module.persistent_volume["pihole"],
  ]
}

module "cert_manager" {
  source = "./modules/cert_manager"

  chart_name     = "cert-manager"
  chart_version  = var.cert_manager_chart_version
  namespace      = kubernetes_namespace.cert_manager.metadata.0.name
  domain         = var.external_domain
  access_key_id  = var.access_key_id
  email_address  = var.email_address
  region         = var.region
  hosted_zone_id = var.hosted_zone_id

  depends_on = [
    module.ingress_nginx,
  ]
}

module "kured" {
  source = "./modules/kured"

  chart_name    = "kured"
  chart_version = var.kured_chart_version
  namespace     = "kube-system"
}

module "grafana_operator" {
  count = false ? 1 : 0

  source                               = "./modules/grafana_operator"
  namespace                            = kubernetes_namespace.monitoring.metadata.0.name
  chart_repository                     = "grafana-operator"
  chart_version                        = var.grafana_operator_chart_version
  grafana_ingress_host                 = "grafana-op.${var.external_domain}"
  grafana_data_source_url              = "http://prometheus-operator-kube-p-prometheus.monitoring.svc:9090"
  grafana_data_source_url_alertmanager = "http://prometheus-operator-kube-p-alertmanager.monitoring.svc:9093"
  grafana_data_source_access           = "direct"

  grafana_labels = {
    "grafana" : "dashboard",
  }

  depends_on = [
    module.ingress_nginx
  ]
}

module "postgres_operator" {
  source                 = "./modules/postgres_operator"
  namespace              = kubernetes_namespace.postgres_operator.metadata.0.name
  operator_chart_version = var.postgres_operator_chart_version
  ui_chart_version       = var.postgres_operator_chart_version
  ui_ingress_host        = "postgresoperator-ui.${var.external_domain}"

  depends_on = [
    module.ingress_nginx
  ]
}

# module "keycloak" {
#   source                               = "./modules/keycloak"
#   namespace                            = kubernetes_namespace.keycloak.metadata.0.name
#   chart_repository                     = "bitnami/keycloak"
#   chart_version                        = var.keycloak_chart_version
#   keycloak_ingress_host                = "keycloak.${var.external_domain}"

#   depends_on = [
#     module.metallb
#   ]
# }
