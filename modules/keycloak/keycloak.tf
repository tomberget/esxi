resource "kubernetes_secret" "prometheus_alertmanager_plugin" {
  metadata {
    name      = "prometheus-alertmanager-plugin"
    namespace = var.namespace
  }
  data = {
    GF_INSTALL_PLUGINS = "camptocamp-prometheus-alertmanager-datasource"
  }
}

resource "kubernetes_persistent_volume" "grafana_operator" {
  metadata {
    name = "grafana-operator-local-storage-pv"
  }
  spec {
    capacity = {
      storage = "4Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/grafana/operator"
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

resource "helm_release" "grafana_operator" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = var.chart_repository
  version    = var.chart_version
  values = [
    templatefile("${path.module}/grafana_operator.yaml", {
      grafana_ingress_url           = var.grafana_ingress_host
      grafana_ingress_tls           = "${replace(var.grafana_ingress_host, ".", "-")}-tls"
      prometheus_data_source_url    = var.grafana_data_source_url
      alertmanager_data_source_url  = var.grafana_data_source_url_alertmanager
      prometheus_data_source_access = var.grafana_data_source_access
      grafana_labels                = indent(4, yamlencode(var.grafana_labels))
    }),
  ]

  depends_on = [
    kubernetes_persistent_volume.grafana_operator,
    kubernetes_secret.prometheus_alertmanager_plugin,
  ]
}
