resource "kubernetes_storage_class" "default" {
  metadata {
    name = "local-storage"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_storage_class" "vsphere" {
  metadata {
    name = "fast"
  }
  storage_provisioner = "kubernetes.io/vsphere-volume"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type = "nfs"
    diskformat = "zeroedthick"
    datastore = "kubernetes"
  }
}
