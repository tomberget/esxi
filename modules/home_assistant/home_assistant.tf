resource "kubernetes_namespace" "home_assistant" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume" "home_assistant" {
  metadata {
    name = "home-assistant-local-storage-pv"
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

resource "helm_release" "home_assistant" {
  name       = var.chart_name
  namespace  = kubernetes_namespace.home_assistant.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      enable_host_network = var.enable_host_network
    })
  ]

  depends_on = [kubernetes_persistent_volume.home_assistant]
}

resource "kubernetes_manifest" "traefik_ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "${var.chart_name}-ingressroute"
      namespace = kubernetes_namespace.home_assistant.metadata[0].name
    }

    spec = {
      entryPoints = [
        "web", 
      ]
      routes = [
        {
          kind     = "Rule"
          match    = "Host(`${var.chart_name}.${var.domain}`)"
          services = [
            {
              name           = var.chart_name
              port           = "http"
            }
          ]
        }
      ]
    }
  }
}
