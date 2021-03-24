resource "kubernetes_namespace" "plex" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"   = "enabled"
      "plex.io/member-of" = "istio-system"
    }
  }
}

resource "kubernetes_persistent_volume" "plex_transcode" {
  metadata {
    name = "plex-transcode-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "20Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/plex/transcode"
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

resource "kubernetes_persistent_volume" "plex_data" {
  metadata {
    name = "plex-data-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "15Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/plex/data"
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

resource "kubernetes_persistent_volume" "plex_config" {
  metadata {
    name = "plex-config-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "15Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/plex/config"
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

data "template_file" "plex_config" {
  template = file("${path.root}/modules/plex/config.yaml")
  vars = {

  }
}

resource "helm_release" "plex" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.plex.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    data.template_file.plex_config.rendered
  ]
}

resource "kubernetes_manifest" "plex_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.app_name}-gateway"
      namespace = var.namespace
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

  depends_on = [ helm_release.plex ]
}

resource "kubernetes_manifest" "plex_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.app_name
      namespace = var.namespace
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
                host = "${var.app_name}-tcp"
                port = {
                  number = 32400
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.plex_gateway ]
}
