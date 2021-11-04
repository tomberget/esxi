resource "kubernetes_manifest" "issuer" {

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "letsencrypt-issuer"
    }

    spec = {
      acme = {
        email  = var.email_address
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "acme-issuer-account-key"
        }
        solvers = [
          {
            selector = {
              dnsZones = [
                var.domain
              ]
            }
            "dns01" = {
              cnameStrategy = "Follow"
              route53 = {
                region       = var.region
                accessKeyID  = var.access_key_id
                hostedZoneID = var.hosted_zone_id
                secretAccessKeySecretRef = {
                  name = "route53-credentials"
                  key  = "secret-access-key"
                }
              }
            }
          },
        ]
      }
    }
  }

  depends_on = [
    helm_release.cert_manager
  ]
}
