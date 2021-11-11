module "cilium" {
  source = "./modules/cilium"

  chart_name    = "cilium"
  chart_version = "1.10.4"
  namespace     = "kube-system"

  domain = var.external_domain
}

module "metallb" {
  source = "./modules/metallb"

  chart_name    = "metallb"
  chart_version = "2.5.5"
  namespace     = "metallb"

  network_range = var.metallb_network_range
}

module "monitoring" {
  source = "./modules/monitoring"

  chart_version = "19.2.3"
  namespace     = "monitoring"

  domain = var.external_domain
}

module "home_assistant" {
  source = "./modules/home_assistant"

  chart_version = "11.0.0"
  namespace     = "home-assistant"
  chart_name    = "home-assistant"

  enable_host_network = true
  ha_metrics_token    = var.ha_metrics_token

  app_name = "ha"
  domain   = var.external_domain
}

module "node_red" {
  source = "./modules/node_red"

  chart_name    = "node-red"
  chart_version = "9.0.1"
  namespace     = "node-red"
  domain        = var.external_domain
}

module "traefik" {
  source = "./modules/traefik"

  chart_name         = "traefik"
  chart_version      = "10.6.0"
  namespace          = "traefik"
  metallb_traefik_ip = cidrhost(var.metallb_network_range, var.metallb_traefik_ip_hostnum)
  domain             = var.external_domain

  depends_on = [
    module.metallb
  ]
}

module "pihole" {
  source = "./modules/pihole"

  chart_name        = "pihole"
  chart_version     = "2.4.2"
  namespace         = "pihole"
  domain            = var.domain
  metallb_pihole_ip = cidrhost(var.metallb_network_range, var.metallb_pihole_ip_hostnum)

  depends_on = [
    module.metallb,
    resource.kubernetes_storage_class.vsphere
  ]
}

module "cert_manager" {
  source = "./modules/cert_manager"

  chart_name     = "cert-manager"
  chart_version  = "1.6.1"
  namespace      = "cert-manager"
  domain         = var.external_domain
  access_key_id  = var.access_key_id
  email_address  = var.email_address
  region         = var.region
  hosted_zone_id = var.hosted_zone_id

  depends_on = [
    module.metallb,
  ]
}

module "kured" {
  source = "./modules/kured"

  chart_name    = "kured"
  chart_version = "2.10.0"
  namespace     = "kube-system"
}
# # module "step_certificates" {
# #   source = "./modules/step_certificates"

# #   step_certificates_chart_version = "1.15.5"
# #   step_certificates_namespace = "step-certificates"
# # }
