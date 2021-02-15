resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

data "template_file" "this" {
  template = file("${path.root}/modules/ingress_nginx/config.yaml")
  vars = {

  }
}

resource "helm_release" "this" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.this.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.chart_version

  values = [
    data.template_file.this.rendered
  ]
}
