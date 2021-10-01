module "cilium" {
  source = "./modules/cilium"

  chart_name    = "cilium"
  chart_version = "1.10.4"
  namespace     = "kube-system"

  domain = var.domain
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

  chart_version = "19.0.1"
  namespace     = "monitoring"

  domain = var.domain
}

module "home_assistant" {
  source = "./modules/home_assistant"

  chart_version = "11.0.0"
  namespace     = "home-assistant"
  chart_name    = "home-assistant"

  enable_host_network = true
  ha_metrics_token    = var.ha_metrics_token

  app_name = "ha"
  domain   = var.domain
}

module "node_red" {
  source = "./modules/node_red"

  chart_name    = "node-red"
  chart_version = "9.0.1"
  namespace     = "node-red"
  domain        = var.domain
}

module "traefik" {
  source = "./modules/traefik"

  chart_name         = "traefik"
  chart_version      = "10.3.1"
  namespace          = "traefik"
  metallb_traefik_ip = cidrhost(var.metallb_network_range, var.metallb_traefik_ip_hostnum)

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

# # module "step_certificates" {
# #   source = "./modules/step_certificates"

# #   step_certificates_chart_version = "1.15.5"
# #   step_certificates_namespace = "step-certificates"
# # }
