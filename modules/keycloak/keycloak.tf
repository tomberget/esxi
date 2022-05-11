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
}
