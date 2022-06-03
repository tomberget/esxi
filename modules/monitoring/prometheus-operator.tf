resource "random_password" "grafana" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create/Update CRDs
resource "kubernetes_manifest" "prometheus_operator_crd" {
  for_each = toset(["alertmanagerconfigs", "alertmanagers", "podmonitors", "probes", "prometheuses", "prometheusrules", "servicemonitors", "thanosrulers"])
  manifest = yamldecode(file("${path.module}/crds/v${var.operator_version}/monitoring.coreos.com_${each.key}.yaml"))

  field_manager {
    force_conflicts = true
  }
}

resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      alertmanager_ingress_host = "alertmanager.${var.domain}"
      alertmanager_tls_name     = "alertmanager-${replace(var.domain, ".", "-")}-tls"

      prometheus_ingress_host = "prometheus.${var.domain}"
      prometheus_tls_name     = "prometheus-${replace(var.domain, ".", "-")}-tls"

      grafana_ingress_host = "grafana.${var.domain}"
      grafana_tls_name     = "grafana-${replace(var.domain, ".", "-")}-tls"
      grafana_org_name     = var.grafana_org_name
      grafana_password     = random_password.grafana.result

      prometheus_operator_create_crd = false
    })
  ]

  depends_on = [
    kubernetes_manifest.prometheus_operator_crd,
  ]
}
