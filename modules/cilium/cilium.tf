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
