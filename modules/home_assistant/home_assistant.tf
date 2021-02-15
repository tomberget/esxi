resource "kubernetes_namespace" "home_assistant" {
  metadata {
    name = var.home_assistant_namespace

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }
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
    access_modes = ["ReadWriteOnce"]
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
            key = "kubernetes.io/hostname"
            operator = "In"
            values = ["k8node1", "k8node2"]
          }
        }
      }
    }
  }
}

data "template_file" "home_assistant_config" {
  template = file("${path.root}/modules/home_assistant/config.yaml")
  vars = {
    enable_host_network = var.enable_host_network
  }
}

resource "helm_release" "home_assistant" {
  name       = "home-assistant"
  namespace  = kubernetes_namespace.home_assistant.metadata[0].name
  repository = "https://k8s-at-home.com/charts/"
  chart      = "home-assistant"
  version    = var.home_assistant_chart_version

  values = [
    data.template_file.home_assistant_config.rendered
  ]

  depends_on = [kubernetes_persistent_volume.home_assistant]
}