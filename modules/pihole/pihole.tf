resource "random_password" "pihole" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "pihole" {
  metadata {
    name      = "password"
    namespace = var.namespace
  }

  data = {
    password = random_password.pihole.result
  }

  type = "opaque"
}

resource "kubernetes_persistent_volume" "pihole" {
  count = var.enable_persistent_volume ? 1 : 0

  metadata {
    name = "pihole-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "500Mi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    mount_options = [
      "nfsvers=3",
      "noatime",
      "nolock",
      "all_squash",
      "anonuid=1000",
      "anongid=65533",
    ]
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/pihole"
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

resource "helm_release" "pihole" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://mojo2600.github.io/pihole-kubernetes/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      secret_name              = kubernetes_secret.pihole.metadata[0].name
      metallb_pihole_ip        = var.metallb_pihole_ip
      ingress_host             = "${var.chart_name}.${var.domain}"
      tls_secret               = "${var.chart_name}-${replace(var.domain, ".", "-")}-tls"
      enable_persistent_volume = var.enable_persistent_volume
    })
  ]

  depends_on = [kubernetes_persistent_volume.pihole]
}
