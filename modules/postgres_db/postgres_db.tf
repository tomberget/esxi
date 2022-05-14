locals {
  labels = {
    postgres    = local.name
    team        = var.team
    application = "spilo"
  }
  name        = format("%s-%s", var.team, var.name)
  secret_name = replace(format("%s.%s.credentials.postgresql.acid.zalan.do", element(keys(var.users), 0), local.name), "_", "-")
  database    = element(keys(var.databases), 0)
}

resource "kubernetes_persistent_volume" "postgres_db" {
  metadata {
    name = local.name
  }
  spec {
    capacity = {
      storage = var.volume_size
    }

    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"

    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path = format("/mnt/default/kubernetes/postgres/%s", local.name)
      }
    }
  }
}

resource "kubernetes_manifest" "postgres_db" {
  manifest = {
    apiVersion = "acid.zalan.do/v1"
    kind       = "postgresql"

    metadata = {
      name      = local.name
      namespace = var.namespace
      labels = {
        team = var.team
      }
    }

    spec = {
      # Prometheus postgres exporter
      sidecars = [{
        navn  = var.exporter_name
        image = var.exporter_image
        ports = [{
          name          = var.exporter_name
          containerPort = 9187
          protocol      = "TCP"
        }]
        resources = {
          limits = {
            memory : var.exporter_limits_memory
          }
          requests = {
            cpu : var.exporter_requests_cpu
            memory : var.exporter_requests_memory
          }
        }
        env = [
          {
            name : "DATA_SOURCE_URI"
            value : "localhost/${local.database}?sslmode=disable"
          },
          {
            name = "DATA_SOURCE_USER"
            valueFrom = {
              secretKeyRef = {
                name : "${local.secret_name}",
                key : "username",
              }
            }
          },
          {
            name = "DATA_SOURCE_PASS"
            valueFrom = {
              secretKeyRef = {
                name : "${local.secret_name}",
                key : "password",
              }
            }
          },
        ]
      }]

      teamId = var.team
      postgresql = {
        version = var.postgres_version
      }
      numberOfInstances         = var.instances
      enableMasterLoadBalancer  = var.enable_master_load_balancer
      enableReplicaLoadBalancer = var.enable_replica_load_balancer
      enableConnectionPooler    = var.enable_connection_pooler
      volume = {
        size         = var.volume_size
        storageClass = kubernetes_persistent_volume.postgres_db.spec[0].storage_class_name
      }
      users     = var.users
      databases = var.databases

      resources = {
        requests = {
          cpu    = var.requests_cpu
          memory = var.requests_memory
        }
        limits = {
          memory = var.limits_memory
        }
      }
    }
  }
}

resource "kubernetes_manifest" "podmonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PodMonitor"

    metadata = {
      name      = kubernetes_manifest.postgres_db.manifest.metadata.name
      namespace = var.namespace
      labels = {
        for k, v in local.labels : k => v
      }
    }
    spec = {
      jobLabel = local.name
      selector = {
        matchLabels = local.labels
      }
      namespaceSelector = {
        matchNames = [var.namespace]
      }
      podMetricsEndpoints = [
        {
          port     = var.exporter_name
          path     = var.scrape_path
          interval = var.scrape_interval
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "prometheusrule" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"
    metadata = {
      name      = kubernetes_manifest.podmonitor.manifest.metadata.name
      namespace = var.namespace
      annotations = {
        "prometheus-operator-validated" = "true"
      }
      labels = {
        for k, v in local.labels : k => v
      }
    }
    spec = {
      groups = [
        {
          name = local.name
          rules = [
            {
              alert = "postgres_down"
              annotations = {
                message     = "Postgres is down"
                description = "Postgres is down"
              }
              expr = "sum(pg_up{pod=~\"${local.name}.+\", namespace=\"${var.namespace}\"}) by (job, namespace) / ${var.instances} != 1"
              for  = "5m"
              labels = {
                severity     = "warning",
                installed_by = "terraform",
                name         = local.name,
                team         = var.team,
                database     = local.database,
              }
            }
          ]
        }
      ]
    }
  }
}
