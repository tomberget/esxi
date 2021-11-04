resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "${var.name}-ingressroute"
      namespace = var.namespace
    }

    spec = {
      entryPoints = var.entry_points
      routes = [
        {
          kind  = var.route_kind
          match = var.route_match
          services = [
            {
              kind           = var.service_kind
              name           = var.service_name
              namespace      = var.namespace
              passHostHeader = var.service_pass_host_header
              responseForwarding = {
                flushInterval = var.service_responseForwarding_flushInterval
              }
              scheme = var.service_scheme
              port   = var.service_port
            }
          ]
        }
      ]
    }
  }
}
