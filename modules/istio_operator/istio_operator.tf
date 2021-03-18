resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.istio_namespace
  }
}


resource "helm_release" "istio_operator" {
  name       = var.chart_name
  namespace  = var.operator_namespace
  repository = "https://stevehipwell.github.io/helm-charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      istio_namespace = kubernetes_namespace.istio_system.metadata.0.name
    })
  ]
}
