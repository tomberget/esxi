module "cilium" {
  source = "./modules/cilium"

  chart_name    = "cilium"
  chart_version = "1.9.4"
  namespace     = "kube-system"
}

module "metallb" {
  source = "./modules/metallb"

  chart_name    = "metallb"
  chart_version = "2.3.0"
  namespace     = "metallb"

  network_range = var.network_range
}

module "istio_operator" {
  source = "./modules/istio_operator"

  chart_name         = "istio-operator"
  chart_version      = "2.1.2"
  operator_namespace = "default"
  istio_namespace    = "istio-system"
}

module "kiali_operator" {
  source = "./modules/kiali_operator"

  chart_name    = "kiali-operator"
  chart_version = "1.30.0"
  namespace     = "kiali-operator"

  app_name = "kiali"
  domain   = var.domain
}

module "monitoring" {
  source = "./modules/monitoring"

  prometheus_operator_chart_version = "14.0.0"
  prometheus_namespace              = "monitoring"

  # ingress_host = var.dns_zone
}

# module "home_assistant" {
#   source = "./modules/home_assistant"

#   home_assistant_chart_version = "2.6.0"
#   home_assistant_namespace     = "home-assistant"

#   enable_host_network          = true
# }

# module "node_red" {
#   source = "./modules/node_red"

#   name          = "node-red"
#   chart_version = "6.1.0"
#   namespace     = "node-red"
#   domain_name   = var.domain_name
# }

# # module "step_certificates" {
# #   source = "./modules/step_certificates"

# #   step_certificates_chart_version = "1.15.5"
# #   step_certificates_namespace = "step-certificates"
# # }
