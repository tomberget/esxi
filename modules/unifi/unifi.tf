resource "kubernetes_namespace" "unifi" {
  metadata {
    name = var.namespace

    labels = {
    }
  }
}

resource "kubernetes_persistent_volume" "unifi" {
  metadata {
    name = "unifi-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/unifi"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["k8node1", "k8node2"]
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume" "unifi_mongodb" {
  metadata {
    name = "unifi-mongodb-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "20Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/unifi_mongodb"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["k8node1", "k8node2"]
          }
        }
      }
    }
  }
}

resource "helm_release" "unifi" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.unifi.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      service_name = var.chart_name
      ingress_path = "controller.${var.domain}"
      tls_name     = "controller-${replace(var.domain, ".", "-")}-tls"
    })
  ]

  depends_on = [
    kubernetes_persistent_volume.unifi,
    kubernetes_persistent_volume.unifi_mongodb,
  ]
}

# module "traefik_ingress_route" {
#   source = "../traefik_ingress_route"

#   name           = "${var.chart_name}-controller"
#   service_name   = var.chart_name
#   namespace      = kubernetes_namespace.unifi.metadata[0].name
#   route_match    = "Host(`controller.${var.domain}`) && PathPrefix(`/`)"
#   service_port   = "http"
#   entry_points   = ["web", "websecure",]

#   depends_on = [
#     helm_release.unifi
#   ]
# }
