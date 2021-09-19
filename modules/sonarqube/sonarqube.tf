resource "helm_release" "sonarqube" {
  count = var.sonar_enabled ? 1 : 0 && var.sonar_official ? 0 : 1

  name       = "sonarqube"
  repository = var.sonar_chart_repository
  chart      = "sonarqube"
  version    = var.sonar_chart_version
  namespace  = var.sonar_namespace

  values = [
    templatefile("${path.module}/${var.sonar_reference_key}_values.yaml", {
      image_tag          = var.sonar_image_tag
      ldap_bind_password = var.sonar_ldap_bind_password
      sonar_ingress_host = var.sonar_ingress_host
    }),
  ]
}
