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

module "istio_gateway" {
  source = "../istio_gateway"

  ingress_name = "hubble"
  ingress_host = var.domain
  namespace    = var.namespace
  service_name = "hubble-ui"
  service_port = 80

  depends_on = [
    helm_release.cilium,
  ]
}