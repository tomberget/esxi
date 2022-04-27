data "kubernetes_all_namespaces" "all_namespaces" {}

module "cilium" {
  source = "./modules/cilium"

  chart_name    = "cilium"
  chart_version = "1.11.1"
  namespace     = "kube-system"

  domain = var.external_domain
}

module "metallb" {
  source = "./modules/metallb"

  chart_name    = "metallb"
  chart_version = "2.6.2"
  namespace     = kubernetes_namespace.metallb.metadata.0.name

  network_range = var.metallb_network_range

  depends_on = [
    module.cilium
  ]
}

module "monitoring" {
  source = "./modules/monitoring"

  chart_version = "32.2.1"
  namespace     = kubernetes_namespace.monitoring.metadata.0.name

  domain = var.external_domain

  depends_on = [
    module.ingress_nginx,
  ]
}

module "home_assistant" {
  source = "./modules/home_assistant"

  chart_version = "12.0.1"
  namespace     = kubernetes_namespace.home_assistant.metadata.0.name
  chart_name    = "home-assistant"

  enable_host_network = true
  ha_metrics_token    = var.ha_metrics_token

  app_name = "ha"
  domain   = var.external_domain

  depends_on = [
    module.monitoring,
  ]
}

module "node_red" {
  source = "./modules/node_red"

  chart_name    = "node-red"
  chart_version = "10.0.0"
  namespace     = kubernetes_namespace.home_assistant.metadata.0.name
  domain        = var.external_domain

  depends_on = [
    module.home_assistant
  ]
}

module "ingress_nginx" {
  source = "./modules/ingress_nginx"

  chart_name               = "ingress-nginx"
  chart_version            = "4.1.0"
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
  chart_version     = "2.5.8"
  namespace         = kubernetes_namespace.pihole.metadata.0.name
  domain            = var.external_domain
  metallb_pihole_ip = cidrhost(var.metallb_network_range, var.metallb_pihole_ip_hostnum)

  depends_on = [
    module.ingress_nginx
  ]
}

module "cert_manager" {
  source = "./modules/cert_manager"

  chart_name     = "cert-manager"
  chart_version  = "1.8.0"
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
  chart_version = "2.11.2"
  namespace     = "kube-system"
}

module "grafana_operator" {
  count = false ? 1 : 0

  source                               = "./modules/grafana_operator"
  namespace                            = kubernetes_namespace.monitoring.metadata.0.name
  chart_repository                     = "grafana-operator"
  chart_version                        = "1.5.3"
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
  operator_chart_version = "1.7.1"
  ui_chart_version       = "1.7.1"
  ui_ingress_host        = "postgresoperator-ui.${var.external_domain}"

  depends_on = [
    module.ingress_nginx
  ]
}
