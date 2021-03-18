resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.namespace

    labels = {
      "istio-injection" = "enabled"
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

resource "kubernetes_manifest" "prometheus_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.prom_app_name}-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          hosts = [
            "${var.prom_app_name}.${var.domain}",
          ]
          port = {
            name = "http"
            number = 80
            protocol = "HTTP"
          }
        },
      ]
    }
  }

  depends_on = [ helm_release.prometheus_operator ]
}

resource "kubernetes_manifest" "prometheus_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.prom_app_name
      namespace = var.namespace
    }
    spec = {
      gateways = [
        "${var.prom_app_name}-gateway",
      ]
      hosts = [
        "${var.prom_app_name}.${var.domain}",
      ]
      http = [
        {
          match = [
            {
              uri = {
                prefix = "/"
              }
            },
          ]
          route = [
            {
              destination = {
                host = "prometheus-operator-kube-p-prometheus"
                port = {
                  number = 9090
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.prometheus_gateway ]
}

resource "kubernetes_manifest" "alertmanager_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.alrt_app_name}-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          hosts = [
            "${var.alrt_app_name}.${var.domain}",
          ]
          port = {
            name = "http"
            number = 80
            protocol = "HTTP"
          }
        },
      ]
    }
  }

  depends_on = [ helm_release.prometheus_operator ]
}

resource "kubernetes_manifest" "alertmanager_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.alrt_app_name
      namespace = var.namespace
    }
    spec = {
      gateways = [
        "${var.alrt_app_name}-gateway",
      ]
      hosts = [
        "${var.alrt_app_name}.${var.domain}",
      ]
      http = [
        {
          match = [
            {
              uri = {
                prefix = "/"
              }
            },
          ]
          route = [
            {
              destination = {
                host = "prometheus-operator-kube-p-alertmanager"
                port = {
                  number = 9093
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.alertmanager_gateway ]
}

resource "kubernetes_manifest" "grafana_gateway" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "Gateway"
    metadata = {
      name = "${var.graf_app_name}-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          hosts = [
            "${var.graf_app_name}.${var.domain}",
          ]
          port = {
            name = "http"
            number = 80
            protocol = "HTTP"
          }
        },
      ]
    }
  }

  depends_on = [ helm_release.prometheus_operator ]
}

resource "kubernetes_manifest" "grafana_virtual_service" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind = "VirtualService"
    metadata = {
      name = var.graf_app_name
      namespace = var.namespace
    }
    spec = {
      gateways = [
        "${var.graf_app_name}-gateway",
      ]
      hosts = [
        "${var.graf_app_name}.${var.domain}",
      ]
      http = [
        {
          match = [
            {
              uri = {
                prefix = "/"
              }
            },
          ]
          route = [
            {
              destination = {
                host = "prometheus-operator-grafana"
                port = {
                  number = 80
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [ kubernetes_manifest.grafana_gateway ]
}
