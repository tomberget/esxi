module "esxi" {
  source = "./modules/external_service"

  service_name    = "esxi"
  service_port    = 443
  ingress_path    = "/"
  domain          = var.domain
  external_domain = var.external_domain

}

module "controller" {
  source = "./modules/external_service"

  service_name    = "controller"
  service_port    = 8443
  ingress_path    = "/"
  domain          = var.domain
  external_domain = var.external_domain

}
