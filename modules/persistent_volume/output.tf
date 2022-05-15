output "storage_class_name" {
  value = kubernetes_persistent_volume.persistent_volume.spec[0].storage_class_name
}
