resource "kubernetes_namespace" "home_assistant" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection" = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "kubernetes_persistent_volume" "home_assistant" {
  metadata {
    name = "home-assistant-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/home-assistant"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key = "kubernetes.io/hostname"
            operator = "In"
            values = ["k8node1", "k8node2"]
          }
        }
      }
    }
  }
}

resource "helm_release" "home_assistant" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.home_assistant.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      enable_host_network = var.enable_host_network
    })
  ]

  depends_on = [kubernetes_persistent_volume.home_assistant]
}

resource "kubernetes_manifest" "home_assistant_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.chart_name}-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          hosts = [
            "${var.chart_name}.${var.domain}",
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

  depends_on = [ helm_release.home_assistant ]
}

resource "kubernetes_manifest" "home_assistant_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.chart_name
      namespace = var.namespace
    }
    spec = {
      gateways = [
        "${var.chart_name}-gateway",
      ]
      hosts = [
        "${var.chart_name}.${var.domain}",
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
                host = "${var.chart_name}.${var.namespace}.svc.cluster.local"
                port = {
                  number = 8123
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.home_assistant_gateway ]
}
