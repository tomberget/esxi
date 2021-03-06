resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection"         = "enabled"
      "prometheus.io/member-of" = "istio-system"
    }
  }
}


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
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      grafana_org_name = var.grafana_org_name
      grafana_password = random_password.grafana.result

      prometheus_operator_create_crd = true
    })
  ]
}

module "istio_gateway_prometheus" {
  source = "../istio_gateway"

  ingress_name = "prometheus"
  ingress_host = var.domain
  namespace    = kubernetes_namespace.prometheus.metadata[0].name
  service_name = "prometheus-operator-kube-p-prometheus"
  service_port = 9090

  depends_on = [
    helm_release.prometheus_operator,
  ]
}

module "istio_gateway_alertmanager" {
  source = "../istio_gateway"

  ingress_name = "alertmanager"
  ingress_host = var.domain
  namespace    = kubernetes_namespace.prometheus.metadata[0].name
  service_name = "prometheus-operator-kube-p-alertmanager"
  service_port = 9093

  depends_on = [
    helm_release.prometheus_operator,
  ]
}

module "istio_gateway_grafana" {
  source = "../istio_gateway"

  ingress_name = "grafana"
  ingress_host = var.domain
  namespace    = kubernetes_namespace.prometheus.metadata[0].name
  service_name = "prometheus-operator-grafana"
  service_port = 80

  depends_on = [
    helm_release.prometheus_operator,
  ]
}
