resource "kubernetes_namespace" "kiali_operator" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "helm_release" "kiali_operator" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.kiali_operator.metadata[0].name
  repository = "https://kiali.org/helm-charts"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      
    })
  ]
}

module "istio_gateway" {
  source = "../istio_gateway"

  ingress_name = var.chart_name
  ingress_host = var.domain
  namespace    = kubernetes_namespace.kiali_operator.metadata[0].name
  service_port = 20001

  depends_on = [
    helm_release.kiali_operator,
  ]
}
