resource "helm_release" "ingress_nginx" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      metallb_traefik_ip = var.metallb_ingress_nginx_ip
      controller_replica = var.controller_replica
      namespace          = var.namespace
    })
  ]
}
