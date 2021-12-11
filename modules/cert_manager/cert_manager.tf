resource "helm_release" "cert_manager" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://charts.jetstack.io"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
    })
  ]
}
