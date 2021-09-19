resource "kubernetes_namespace" "sonar" {
  metadata {
    name = var.sonar_namespace
  }
}

resource "kubernetes_persistent_volume" "sonar_postgresql" {
  metadata {
    name = "sonar-postgresql-local-storage-pv"
    labels = {
      app     = "postgresql"
      release = "sonarqube"
    }
  }
  spec {
    capacity = {
      storage = "20Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/sonar/postgresql"
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

resource "kubernetes_persistent_volume" "sonar" {
  metadata {
    name = "sonar-local-storage-pv"
    labels = {
      app     = "sonarqube"
      release = "sonarqube"
    }
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/sonar/sonar"
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

module "sonarqube_helm_chart" {
  for_each = {
    for k, v in var.sonar_helm_chart : k => v
    if var.sonar_enabled == true && tobool(v.official) == var.sonar_enable_official
  }

  source                   = "./modules/sonarqube"
  sonar_enabled            = var.sonar_enabled
  sonar_official           = tobool(each.value.official)
  sonar_namespace          = kubernetes_namespace.sonar.metadata.0.name
  sonar_chart_repository   = each.value.chart_repository
  sonar_chart_version      = each.value.chart_version
  sonar_image_tag          = each.value.image_tag
  sonar_ldap_bind_password = var.sonar_ldap_bind_password
  sonar_ingress_host       = var.sonar_ingress_host
  sonar_reference_key      = each.key

  depends_on = [
    kubernetes_persistent_volume.sonar_postgresql,
    kubernetes_persistent_volume.sonar,
  ]
}
