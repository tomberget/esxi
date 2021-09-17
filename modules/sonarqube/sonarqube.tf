resource "helm_release" "sonarqube" {
  count = var.sonar_enabled ? 1 : 0

  name       = "sonarqube"
  repository = var.sonar_chart_repository
  chart      = "sonarqube"
  version    = var.sonar_chart_version
  namespace  = var.sonar_namespace

  values = [
    templatefile("${path.module}/values.yaml", {
      image_tag          = var.sonar_image_tag
      ldap_bind_password = var.sonar_ldap_bind_password
      sonar_ingress_host = var.sonar_ingress_host
    }),
  ]
}
