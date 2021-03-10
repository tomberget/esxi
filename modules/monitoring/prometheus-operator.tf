resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.prometheus_namespace

    labels = {
      # "istio-injection"    = "enabled"
      # "kiali.io/member-of" = "istio-system"
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
    access_modes = ["ReadWriteOnce"]
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
            key = "kubernetes.io/hostname"
            operator = "In"
            values = ["k8node1", "k8node2"]
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
    access_modes = ["ReadWriteOnce"]
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
            key = "kubernetes.io/hostname"
            operator = "In"
            values = ["k8node1", "k8node2"]
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
    access_modes = ["ReadWriteOnce"]
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
            key = "kubernetes.io/hostname"
            operator = "In"
            values = ["k8node1", "k8node2"]
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

data "template_file" "prometheus_operator_config" {
  template = file("${path.root}/modules/monitoring/config.yaml")
  vars = {

    grafana_org_name = var.grafana_org_name
    grafana_password = random_password.grafana.result

    prometheus_operator_create_crd = true
  }
}

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus_operator_chart_version

  values = [
    data.template_file.prometheus_operator_config.rendered
  ]
}