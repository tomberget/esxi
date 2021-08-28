resource "helm_release" "cilium" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://helm.cilium.io"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {

    })
  ]
}

module "ingress_route" {
  source = "../traefik_ingress_route"

  name         = "hubble-ui"
  service_name = "hubble-ui"
  namespace    = var.namespace
  route_match  = "Host(`hubble.${var.domain}`) && PathPrefix(`/`)"
  service_port = "http"
}
