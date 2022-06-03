locals {
  persistent_volumes = {
    "pihole" = {
      labels = {
        "app" = "pihole"
      }

      volume_size  = "500Mi"
      leading_path = ""
    }
    "home-assistant" = {
      labels = {
        "app.kubernetes.io/instance" = "home-assistant"
        "app.kubernetes.io/name"     = "home-assistant"
      }

      volume_size  = "5Gi"
      leading_path = ""
    }
    "node-red" = {
      labels = {
        "app.kubernetes.io/instance" = "node-red"
        "app.kubernetes.io/name"     = "node-red"
      }

      volume_size  = "3Gi"
      leading_path = ""
    }
    "alertmanager" = {
      labels = {
        "alertmanager"                 = "prometheus-operator-kube-p-alertmanager"
        "app.kubernetes.io/instance"   = "prometheus-operator-kube-p-alertmanager"
        "app.kubernetes.io/managed-by" = "prometheus-operator"
        "app.kubernetes.io/name"       = "alertmanager"
      }

      volume_size  = "5Gi"
      leading_path = "monitoring/"
    }
    "prometheus" = {
      labels = {
        "app.kubernetes.io/instance"   = "prometheus-operator-kube-p-prometheus"
        "app.kubernetes.io/managed-by" = "prometheus-operator"
        "app.kubernetes.io/name"       = "prometheus"
        "prometheus"                   = "prometheus-operator-kube-p-prometheus"
      }

      volume_size  = "10Gi"
      leading_path = "monitoring/"
    }
    "grafana" = {
      labels = {
        "app.kubernetes.io/instance" = "prometheus-operator"
        "app.kubernetes.io/name"     = "grafana"
      }

      volume_size  = "5Gi"
      leading_path = "monitoring/"
    }
  }
}

module "persistent_volume" {
  source = "./modules/persistent_volume"

  for_each = local.persistent_volumes

  name                = each.key
  labels              = lookup(each.value, "labels", {})
  volume_size         = lookup(each.value, "volume_size", "1Gi")
  preexisting_subpath = format("%s%s", lookup(each.value, "leading_path", ""), each.key)

  nfs_server = var.nfs_server
}
