# module "monitoring" {
#   source = "./modules/monitoring"

#   prometheus_operator_chart_version = "10.1.0"
#   prometheus_namespace              = "monitoring"

#   # ingress_host = var.dns_zone
# }

# module "home-assistant" {
#   source = "./modules/home_assistant"

#   home_assistant_chart_version = "2.6.0"
#   home_assistant_namespace     = "home-assistant"
# }

module "nfs_client" {
  source = "./modules/nfs_client"

  nfs_client_chart_version = "1.2.10"
  nfs_client_namespace     = "nfs-client"
}