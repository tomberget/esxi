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
    access_modes       = ["ReadWriteOnce"]
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
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["k8node1", "k8node2"]
          }
        }
      }
    }
  }
}

resource "helm_release" "node_red" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.node_red.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {

    })
  ]

  depends_on = [kubernetes_persistent_volume.node_red]
}

module "istio_gateway" {
  source = "../istio_gateway"

  ingress_name = var.chart_name
  ingress_host = var.domain
  namespace    = kubernetes_namespace.node_red.metadata[0].name
  service_port = 1880

  depends_on = [
    helm_release.node_red,
  ]
}