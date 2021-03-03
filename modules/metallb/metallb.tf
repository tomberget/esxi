resource "kubernetes_namespace" "metallb" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

data "template_file" "metallb_config" {
  template = file("${path.root}/modules/metallb/config.yaml")
  vars = {

  }
}

resource "helm_release" "metallb" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.metallb.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    data.template_file.metallb_config.rendered
  ]
}
