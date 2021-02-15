module "metallb" {
  source = "./modules/metallb"

  metallb_chart_version = "2.3.0"
  metallb_namespace     = "metallb"

  # Please note that any changes here MUST be followed by commenting out 
  # nodeSelector and subnodes, and replacing with
  # nodeName: k8master
}

module "ingress_nginx" {
  source = "./modules/ingress_nginx"

  chart_version = "3.23.0"
  namespace     = "ingress-nginx"
}

# module "traefik" {
#   source = "./modules/traefik"

#   traefik_chart_version = "9.11.0"
#   traefik_namespace     = "traefik"
# }

# module "monitoring" {
#   source = "./modules/monitoring"

#   prometheus_operator_chart_version = "10.1.0"
#   prometheus_namespace              = "monitoring"

#   # ingress_host = var.dns_zone
# }

module "home_assistant" {
  source = "./modules/home_assistant"

  home_assistant_chart_version = "2.6.0"
  home_assistant_namespace     = "home-assistant"

  enable_host_network          = true
}

module "node_red" {
  source = "./modules/node_red"

  node_red_chart_version = "3.1.0"
  node_red_namespace     = "node-red"
}

# module "step_certificates" {
#   source = "./modules/step_certificates"

#   step_certificates_chart_version = "1.15.5"
#   step_certificates_namespace = "step-certificates"
# }
