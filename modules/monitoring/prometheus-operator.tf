resource "kubernetes_persistent_volume" "alertmanager" {
  metadata {
    name = "alertmanager-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/monitoring/alertmanager"
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


resource "kubernetes_persistent_volume" "prometheus" {
  metadata {
    name = "prometheus-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/monitoring/prometheus"
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


resource "kubernetes_persistent_volume" "grafana" {
  metadata {
    name = "grafana-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "7Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/monitoring/grafana"
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

resource "random_password" "grafana" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      alertmanager_ingress_host = "alertmanager.${var.domain}"
      alertmanager_tls_name     = "alertmanager-${replace(var.domain, ".", "-")}-tls"

      prometheus_ingress_host = "prometheus.${var.domain}"
      prometheus_tls_name     = "prometheus-${replace(var.domain, ".", "-")}-tls"

      grafana_ingress_host = "grafana.${var.domain}"
      grafana_tls_name     = "grafana-${replace(var.domain, ".", "-")}-tls"
      grafana_org_name     = var.grafana_org_name
      grafana_password     = random_password.grafana.result

      prometheus_operator_create_crd = true
    })
  ]
}
