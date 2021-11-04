resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace

    labels = {
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  repository = "https://charts.jetstack.io"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
    })
  ]
}
