resource "kubernetes_namespace" "node_red" {
  metadata {
    name = var.namespace
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
      ingress_host = "${var.chart_name}.${var.domain}"
      tls_name     = "${var.chart_name}-${replace(var.domain, ".", "-")}-tls"
      service_name = var.chart_name
      service_port = "1880"
    })
  ]

  depends_on = [kubernetes_persistent_volume.node_red]
}
