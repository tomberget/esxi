locals {
  external_service_name = "external-${var.service_name}"
  ingress_host          = "${var.service_name}.${var.external_domain}"
}

resource "kubernetes_service" "external" {
  metadata {
    name      = local.external_service_name
    namespace = var.service_namespace
  }

  spec {
    external_name = "${var.service_name}.${var.domain}"
    type          = "ExternalName"
  }
}

resource "kubernetes_ingress" "external" {
  metadata {
    name      = local.external_service_name
    namespace = var.service_namespace
    annotations = {
      "cert-manager.io/cluster-issuer"               = "letsencrypt-issuer"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.ingress_host
      http {
        path {
          backend {
            service_name = kubernetes_service.external.metadata.0.name
            service_port = var.service_port
          }

          path = var.ingress_path
        }
      }
    }

    tls {
      secret_name = "${replace(local.ingress_host, ".", "-")}-tls"
      hosts       = ["${local.ingress_host}"]
    }
  }
}
