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
