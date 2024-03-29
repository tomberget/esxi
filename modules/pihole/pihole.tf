resource "random_password" "pihole" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "pihole" {
  metadata {
    name      = "password"
    namespace = var.namespace
  }

  data = {
    password = random_password.pihole.result
  }

  type = "opaque"
}

resource "helm_release" "pihole" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://mojo2600.github.io/pihole-kubernetes/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      secret_name              = kubernetes_secret.pihole.metadata[0].name
      metallb_pihole_ip        = var.metallb_pihole_ip
      ingress_host             = "${var.chart_name}.${var.domain}"
      tls_secret               = "${var.chart_name}-${replace(var.domain, ".", "-")}-tls"
      enable_persistent_volume = var.enable_persistent_volume
    })
  ]
}
