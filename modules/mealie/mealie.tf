resource "helm_release" "mealie" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://k8s-at-home.com/charts/"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      ingress_host = "${var.chart_name}.${var.domain}"
      tls_name     = "${var.chart_name}-${replace(var.domain, ".", "-")}-tls"
      service_name = var.chart_name
    })
  ]
}
