locals {
  service_name = var.service_name != "" ?  var.service_name : var.ingress_name
}

resource "kubernetes_manifest" "istio_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.ingress_name}-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          hosts = [
            "${var.ingress_name}.${var.ingress_host}",
          ]
          port = {
            name = "http"
            number = 80
            protocol = "HTTP"
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "istio_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.ingress_name
      namespace = var.namespace
    }
    spec = {
      gateways = [
        kubernetes_manifest.istio_gateway.manifest.metadata.name,
      ]
      hosts = [
        "${var.ingress_name}.${var.ingress_host}",
      ]
      http = [
        {
          match = [
            {
              uri = {
                prefix = "/"
              }
            },
          ]
          route = [
            {
              destination = {
                host = local.service_name
                port = {
                  number = var.service_port
                }
              }
            },
          ]
        },
      ]
    }
  }
}
