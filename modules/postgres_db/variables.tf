variable "name" {
  description = "var.team-var.name will be the name of the postgres cluster"
  type        = string
}

variable "team" {
  description = "The team that should own the database"
  type        = string
  default     = "athome"
}

variable "namespace" {
  description = "The namespace to deploy to"
  type        = string
  default     = "postgres-operator"
}

variable "postgres_version" {
  description = "Version of the postgres database"
  type        = number
  default     = 14
}

variable "instances" {
  description = "Number of instances in the postgres cluster"
  type        = number
  default     = 1
}

variable "enable_master_load_balancer" {
  description = "Enable master load balancer"
  type        = bool
  default     = false
}

variable "enable_replica_load_balancer" {
  description = "Enable replica load balancer"
  type        = bool
  default     = false
}

variable "enable_connection_pooler" {
  description = "Enable connection pooler"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "The size of the pvc used for storage"
  type        = string
  default     = "1Gi"
}

variable "storage_class" {
  description = "Storage class for the pvc"
  type        = string
  default     = "local-storage"
}

variable "users" {
  description = <<EOF
    Users and permissions.
    Example:
    users = {
      "user1": ["superuser", "createdb"]
      "user2": ["createdb"]
    }
  EOF
  type        = map(list(string))
  default     = {}
}

variable "databases" {
  description = <<EOF
    Databases and owners.
    Example:
    databases = {
      "database1": user1
      "database2": user2
    }
  EOF
  type        = map(string)
  default     = {}
}

variable "requests_cpu" {
  description = "Cpu requests for the deployment"
  type        = string
  default     = "100m"
}

variable "requests_memory" {
  description = "Memory requests for the deployment"
  type        = string
  default     = "100Mi"
}

variable "limits_memory" {
  description = "Memory limits for the deployment"
  type        = string
  default     = "500Mi"
}

# Postgres Exporter
variable "metrics_enabled" {
  description = "Add podmonitor for the postgresql cluster"
  type        = bool
  default     = true
}

variable "exporter_image" {
  description = "Image of the postgres exporter"
  type        = string
  default     = "bitnami/postgres-exporter:0.10.1"
}

variable "exporter_name" {
  description = "Name of the exporter"
  type        = string
  default     = "exporter"
}

variable "exporter_requests_cpu" {
  description = "Cpu requests for the exporter sidecar"
  type        = string
  default     = "100m"
}

variable "exporter_requests_memory" {
  description = "Memory requests for the exporter sidecar"
  type        = string
  default     = "100Mi"
}

variable "exporter_limits_memory" {
  description = "Memory limits for the exporter sidecar"
  type        = string
  default     = "500Mi"
}

variable "scrape_path" {
  description = "Path to scrape"
  type        = string
  default     = "/metrics"
}

variable "scrape_interval" {
  description = "Scraping interval"
  type        = string
  default     = "30s"
}

variable "nfs_server" {
  description = "NFS server to mount the persistent volume"
  type        = string
}
