resource "kubernetes_namespace" "home_assistant" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume" "home_assistant" {
  metadata {
    name = "home-assistant-local-storage-pv"
    labels = {
      "app.kubernetes.io/instance" = "home-assistant"
      "app.kubernetes.io/name"     = "home-assistant"
    }
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-storage"
    persistent_volume_source {
      local {
        path = "/mnt/kubeshare/home-assistant"
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

# resource "kubernetes_config_map" "example" {
#   metadata {
#     name = "configuration"
#     namespace = kubernetes_namespace.home_assistant.metadata[0].name
#   }

#   data = {
#     "configuration.yml" = "${file("${path.module}/configs/configuration.yaml")}"
#   }
# }

resource "helm_release" "home_assistant" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.home_assistant.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      enable_host_network = var.enable_host_network
      ha_metrics_token    = var.ha_metrics_token
      ingress_host        = "${var.chart_name}.${var.domain}"
    })
  ]

  depends_on = [kubernetes_persistent_volume.home_assistant]
}

module "traefik_ingress_route" {
  source = "../traefik_ingress_route"

  name         = var.chart_name
  service_name = var.chart_name
  namespace    = kubernetes_namespace.home_assistant.metadata[0].name
  route_match  = "Host(`${var.chart_name}.${var.domain}`) && PathPrefix(`/`)"
  service_port = "http"

  depends_on = [
    helm_release.home_assistant
  ]
}

resource "kubernetes_secret" "prometheus" {
  metadata {
    name = "${var.chart_name}-prometheus-token"
    namespace = kubernetes_namespace.home_assistant.metadata.0.name
  }

  data = {
    token = var.ha_metrics_token
  }

  type = "Opaque"
}

resource "kubernetes_manifest" "home_assistant_servicemonitor" {

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind        = "ServiceMonitor"

    metadata = {
      labels = {
        "app.kubernetes.io/instance" = "home-assistant"
        "app.kubernetes.io/name"     = "home-assistant"
        "prometheus"                 = "default"
      }
      name      = var.chart_name
      namespace = kubernetes_namespace.home_assistant.metadata.0.name
    }

    spec = {
      endpoints = [{
        interval      = "30s"
        path          = "/api/prometheus"
        port          = "http"
        scrapeTimeout = "30s"
        authorization = {
          credentials = {
            key  = "token"
            name = kubernetes_secret.prometheus.metadata.0.name
          }
        }
      }]
      jobLabel = "app.kubernetes.io/name"
      namespaceSelector = {
        matchNames = [
          "home-assistant",
        ]
      }
      selector = {
        matchLabels = {
          "app.kubernetes.io/instance" = "home-assistant"
          "app.kubernetes.io/name"     = "home-assistant"
        }
      }
    }
  }

  depends_on = [
    helm_release.home_assistant
  ]
}
