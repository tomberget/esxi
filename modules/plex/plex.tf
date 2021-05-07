resource "kubernetes_namespace" "plex" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "enabled"
      "kiali.io/member-of" = "istio-system"
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
    access_modes       = ["ReadWriteOnce"]
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
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["k8node1", "k8node2"]
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
      storage = "30Gi"
    }
    access_modes       = ["ReadWriteOnce"]
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
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["k8node1", "k8node2"]
          }
        }
      }
    }
  }
}

data "template_file" "plex_config" {
  template = file("${path.module}/templates/config.yaml")
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

module "istio_gateway" {
  source = "../istio_gateway"

  ingress_name = var.chart_name
  ingress_host = var.domain
  namespace    = kubernetes_namespace.plex.metadata[0].name
  service_port = 32400

  depends_on = [
    helm_release.plex,
  ]
}