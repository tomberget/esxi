resource "kubernetes_namespace" "kiali_operator" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

data "template_file" "kiali_operator_config" {
  template = file("${path.root}/modules/kiali_operator/config.yaml")
  vars = {

  }
}

resource "helm_release" "kiali_operator" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.kiali_operator.metadata[0].name
  repository = "https://kiali.org/helm-charts"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    data.template_file.kiali_operator_config.rendered
  ]
}
