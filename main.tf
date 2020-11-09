resource "kubernetes_storage_class" "default" {
  metadata {
    name = "fast"
  }
  storage_provisioner = "kubernetes.io/vsphere-volume"
  reclaim_policy      = "Retain"
  parameters = {
    diskformat = "thin"
    datastore  = "kubernetes"
  }
  mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
}
