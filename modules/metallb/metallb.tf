resource "kubernetes_namespace" "metallb" {
  metadata {
    name = var.metallb_namespace
  }
}

data "template_file" "metallb_config" {
  template = file("${path.root}/modules/metallb/config.yaml")
  vars = {

  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  namespace  = kubernetes_namespace.metallb.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"
  version    = var.metallb_chart_version

  values = [
    data.template_file.metallb_config.rendered
  ]
}
