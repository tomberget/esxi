resource "kubernetes_namespace" "node_red" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "kubernetes_persistent_volume" "node_red" {
  metadata {
    name = "node-red-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "3Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/node-red"
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

data "template_file" "config" {
  template = file("${path.root}/modules/node_red/config.yaml")
  vars = {
    
  }
}

resource "helm_release" "node_red" {
  name         = var.chart_name
  namespace    = kubernetes_namespace.node_red.metadata[0].name
  repository   = "https://k8s-at-home.com/charts/"
  chart        = var.chart_name
  version      = var.chart_version

  values = [
    data.template_file.config.rendered
  ]

  depends_on = [kubernetes_persistent_volume.node_red]
}

resource "kubernetes_manifest" "node_red_gateway" {
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

  depends_on = [ helm_release.node_red ]
}

resource "kubernetes_manifest" "node_red_virtual_service" {
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
                  number = 1880
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.node_red_gateway ]
}
