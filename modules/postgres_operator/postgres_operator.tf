# CRDs
resource "kubernetes_manifest" "postgres_operator_crd" {
  for_each = toset(["operatorconfiguration", "postgresql", "postgresteam"])
  manifest = yamldecode(file("${path.module}/crds/v${var.operator_chart_version}/${each.key}.crd.yaml"))

  field_manager {
    force_conflicts = true
  }
}

# Operator
resource "helm_release" "postgres_operator" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator/"
  chart      = "postgres-operator"
  version    = var.operator_chart_version
  values = [
    templatefile("${path.module}/values.yaml", {
    }),
  ]

  depends_on = [
    kubernetes_manifest.postgres_operator_crd,
  ]
}

# UI
resource "helm_release" "postgres_operator_ui" {
  name       = "${var.name}-ui"
  namespace  = var.namespace
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui/"
  chart      = "postgres-operator-ui"
  version    = var.ui_chart_version
  values = [
    templatefile("${path.module}/values_ui.yaml", {
      ingress_host = var.ui_ingress_host
      namespace    = var.namespace
      tlsname      = "${replace(var.ui_ingress_host, ".", "-")}-tls"
      teams        = indent(4, yamlencode(var.teams))
    }),
  ]

  depends_on = [
    helm_release.postgres_operator,
  ]
}
