module "cilium" {
  source = "./modules/cilium"

  chart_name    = "cilium"
  chart_version = "1.10.0"
  namespace     = "kube-system"

  domain = var.domain
}

module "metallb" {
  source = "./modules/metallb"

  chart_name    = "metallb"
  chart_version = "2.4.0"
  namespace     = "metallb"

  network_range = var.metallb_network_range
}

module "istio_operator" {
  source = "./modules/istio_operator"

  chart_name         = "istio-operator"
  chart_version      = "2.2.0"
  operator_namespace = "default"
  istio_namespace    = "istio-system"

  depends_on = [
    module.metallb
  ]
}

module "kiali_operator" {
  source = "./modules/kiali_operator"

  chart_name    = "kiali-operator"
  chart_version = "1.35.0"
  namespace     = "kiali-operator"

  app_name      = "kiali"
  app_namespace = "istio-system"
  domain        = var.domain
}

module "monitoring" {
  source = "./modules/monitoring"

  chart_version = "16.1.2"
  namespace     = "monitoring"

  domain = var.domain
}

module "home_assistant" {
  source = "./modules/home_assistant"

  chart_version = "8.3.1"
  namespace     = "home-assistant"
  chart_name    = "home-assistant"

  enable_host_network = true

  app_name = "ha"
  domain   = var.domain
}

module "node_red" {
  source = "./modules/node_red"

  chart_name    = "node-red"
  chart_version = "7.4.0"
  namespace     = "node-red"
  domain        = var.domain
}

module "pihole" {
  source = "./modules/pihole"

  chart_name        = "pihole"
  chart_version     = "1.9.1"
  namespace         = "pihole"
  domain            = var.domain
  metallb_pihole_ip = cidrhost(var.metallb_network_range, var.metallb_pihole_ip_hostnum)

  depends_on = [
    module.metallb,
    resource.kubernetes_storage_class.vsphere
  ]
}

module "unifi" {
  source = "./modules/unifi"

  chart_name                  = "unifi"
  chart_version               = "2.0.4"
  namespace                   = "unifi"
  domain                      = var.domain
  metallb_unifi_gui_ip        = cidrhost(var.metallb_network_range, var.metallb_unifi_gui_ip_hostnum)
  metallb_unifi_controller_ip = cidrhost(var.metallb_network_range, var.metallb_unifi_controller_ip_hostnum)
  metallb_unifi_discovery_ip  = cidrhost(var.metallb_network_range, var.metallb_unifi_discovery_ip_hostnum)
  metallb_unifi_stun_ip       = cidrhost(var.metallb_network_range, var.metallb_unifi_stun_ip_hostnum)

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
