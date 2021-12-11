resource "helm_release" "metallb" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      network_range = var.network_range
    })
  ]
}
