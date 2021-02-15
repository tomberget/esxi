resource "kubernetes_namespace" "node_red" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "disabled"
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
    ingress_host = "${var.name}.${var.domain_name}"
  }
}

resource "helm_release" "node_red" {
  name         = var.name
  namespace    = kubernetes_namespace.node_red.metadata[0].name
  repository   = "https://k8s-at-home.com/charts/"
  chart        = var.name
  version      = var.chart_version

  values = [
    data.template_file.config.rendered
  ]

  depends_on = [kubernetes_persistent_volume.node_red]
}
