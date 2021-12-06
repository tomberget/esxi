resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "ingress_nginx" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      metallb_traefik_ip = var.metallb_ingress_nginx_ip
    })
  ]
}
