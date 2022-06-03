resource "helm_release" "home_assistant" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      enable_host_network = var.enable_host_network
      ha_metrics_token    = var.ha_metrics_token
      ingress_host        = "${var.chart_name}.${var.domain}"
      tls_name            = "${var.chart_name}-${replace(var.domain, ".", "-")}-tls"
      service_name        = var.chart_name
    })
  ]
}

resource "kubernetes_secret" "prometheus" {
  metadata {
    name      = "${var.chart_name}-prometheus-token"
    namespace = var.namespace
  }

  data = {
    token = var.ha_metrics_token
  }

  type = "Opaque"
}

resource "kubernetes_manifest" "home_assistant_servicemonitor" {

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"

    metadata = {
      labels = {
        "app.kubernetes.io/instance" = "home-assistant"
        "app.kubernetes.io/name"     = "home-assistant"
        "prometheus"                 = "default"
      }
      name      = var.chart_name
      namespace = var.namespace
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
