resource "kubernetes_namespace" "metallb" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "helm_release" "metallb" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.metallb.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      network_range = var.network_range
    })
  ]
}
