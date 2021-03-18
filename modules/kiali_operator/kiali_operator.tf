resource "kubernetes_namespace" "kiali_operator" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "helm_release" "kiali_operator" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.kiali_operator.metadata[0].name
  repository = "https://kiali.org/helm-charts"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      
    })
  ]
}

resource "kubernetes_manifest" "kiali_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.app_name}-gateway"
      namespace = "istio-system"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          hosts = [
            "${var.app_name}.${var.domain}",
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

  depends_on = [ helm_release.kiali_operator ]
}

resource "kubernetes_manifest" "kiali_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.app_name
      namespace = "istio-system"
    }
    spec = {
      gateways = [
        "${var.app_name}-gateway",
      ]
      hosts = [
        "${var.app_name}.${var.domain}",
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
                host = var.app_name
                port = {
                  number = 20001
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.kiali_gateway ]
}
