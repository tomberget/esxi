resource "kubernetes_persistent_volume" "persistent_volume" {
  metadata {
    name   = var.name
    labels = var.labels
  }

  spec {
    capacity = {
      storage = var.volume_size
    }

    access_modes       = var.access_modes
    storage_class_name = "local-storage"

    mount_options = [
      "nfsvers=3",
      "noatime",
    ]

    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = format("/mnt/default/kubernetes/%s", var.preexisting_subpath)
      }
    }
  }
}
