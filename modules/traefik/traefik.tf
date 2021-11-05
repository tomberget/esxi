resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "traefik" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  repository = "https://helm.traefik.io/traefik"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      metallb_traefik_ip = var.metallb_traefik_ip
    })
  ]
}