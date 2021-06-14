resource "kubernetes_namespace" "unifi" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

resource "kubernetes_persistent_volume" "unifi" {
  metadata {
    name = "unifi-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "fast"
    persistent_volume_source {
      vsphere_volume {
        volume_path = "[kubernetes] /unifi"
        fs_type    = "ext4"
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
      # secret_name      = kubernetes_secret.unifi.metadata[0].name
      metallb_unifi_gui_ip        = var.metallb_unifi_gui_ip
      metallb_unifi_controller_ip = var.metallb_unifi_controller_ip
      metallb_unifi_discovery_ip  = var.metallb_unifi_discovery_ip
      metallb_unifi_stun_ip       = var.metallb_unifi_stun_ip
    })
  ]

  # depends_on = [
  #   kubernetes_persistent_volume.unifi
  # ]
}
