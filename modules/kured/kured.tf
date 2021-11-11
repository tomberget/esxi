data "kubernetes_namespace" "kured" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kured" {
  name       = var.chart_name
  namespace  = data.kubernetes_namespace.kured.metadata.0.name
  repository = "https://weaveworks.github.io/kured"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      namespace    = data.kubernetes_namespace.kured.metadata.0.name
      service_port = "8080"
    })
  ]
}
