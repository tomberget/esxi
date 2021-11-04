# resource "kubernetes_ingress" "unifi" {
#   metadata {
#     name = var.chart_name
#     namespace = kubernetes_namespace.unifi.metadata.0.name
#     annotations = {
#       "cert-manager.io/cluster-issuer" = "letsencrypt-issuer"
#     }
#   }

#   spec {
#     rule {
#       host = "controller.${var.domain}"
#       http {
#         path {
#           path = "/"
#           backend {
#             service_name = var.chart_name
#             service_port = 8443
#           }
#         }
#       }
#     }

#     tls {
#       hosts = ["controller.${var.domain}"]
#       secret_name = "controller-${replace(var.domain, ".", "-")}-tls"
#     }

#     ingress_class_name = "traefik"
#   }
# }
