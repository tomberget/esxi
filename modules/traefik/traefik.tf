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

resource "kubernetes_manifest" "https_redirect_middleware" {

  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"

    metadata = {
      name      = "https-redirectscheme"
      namespace = kubernetes_namespace.traefik.metadata.0.name
    }

    spec = {
      redirectScheme = {
        scheme    = "https"
        permanent = true
      }
    }
  }

  depends_on = [
    helm_release.traefik
  ]
}

resource "kubernetes_service" "traefik_dashboard" {

  metadata {
    name      = "${var.chart_name}-dashboard"
    namespace = kubernetes_namespace.traefik.metadata.0.name
    labels = {
      "app.kubernetes.io/instance" = var.chart_name
      "app.kubernetes.io/name"     = var.chart_name
    }
  }

  spec {
    type = "ClusterIP"
    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = var.chart_name
    }
    selector = {
      "app.kubernetes.io/instance" = var.chart_name
      "app.kubernetes.io/name"     = var.chart_name
    }
  }

  depends_on = [
    helm_release.traefik
  ]
}

resource "kubernetes_ingress" "traefik_dashboard" {

  metadata {
    name      = "${var.chart_name}-dashboard"
    namespace = kubernetes_namespace.traefik.metadata.0.name
    labels = {
      "app.kubernetes.io/instance" = var.chart_name
      "app.kubernetes.io/name"     = var.chart_name
    }
    annotations = {
      "cert-manager.io/cluster-issuer"                   = "letsencrypt-issuer"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
      "traefik.ingress.kubernetes.io/router.tls"         = "true"
    }
  }

  spec {
    ingress_class_name = var.chart_name
    rule {
      host = "${var.chart_name}-dashboard.${var.domain}"
      http {
        path {
          backend {
            service_name = kubernetes_service.traefik_dashboard.metadata.0.name
            service_port = kubernetes_service.traefik_dashboard.spec.0.port.0.name
          }

          path = "/"
        }
      }
    }

    tls {
      secret_name = "${var.chart_name}-dashboard.${replace(var.domain, ".", "-")}-tls"
      hosts       = ["${var.chart_name}-dashboard.${var.domain}"]
    }
  }
}
