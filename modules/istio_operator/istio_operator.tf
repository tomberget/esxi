resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.istio_namespace
  }
}

data "template_file" "istio_operator_config" {
  template = file("${path.root}/modules/istio_operator/config.yaml")
  vars = {
    istio_namespace = kubernetes_namespace.istio_system.metadata.0.name
  }
}

resource "helm_release" "istio_operator" {
  name       = var.chart_name
  namespace  = var.operator_namespace
  repository = "https://stevehipwell.github.io/helm-charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    data.template_file.istio_operator_config.rendered
  ]
}
