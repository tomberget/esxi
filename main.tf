resource "kubernetes_storage_class" "default" {
  metadata {
    name = "local-storage"
  }
  storage_provisioner  = "kubernetes.io/no-provisioner"
  reclaim_policy       = "Retain"
  volume_binding_mode  = "WaitForFirstConsumer"
}
