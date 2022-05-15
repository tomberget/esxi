variable "name" {
  description = "Name of the persistent volume claim"
  type        = string
  default     = "kubernetes"
}

variable "labels" {
  description = "Labels to add to the persistent volume"
  type        = map(string)
  default     = {}
}

variable "volume_size" {
  description = "Size of the persistent volume claim"
  type        = string
  default     = "1Gi"
}

variable "access_modes" {
  description = "Access modes of the persistent volume"
  type        = list(string)
  default     = ["ReadWriteOnce"]
}

variable "preexisting_subpath" {
  description = "Path to the NFS server, whatever comes next after \\`/mnt/default/kubernetes/\\`"
  type        = string
}

variable "nfs_server" {
  description = "NFS server to mount the persistent volume"
  type        = string
}
