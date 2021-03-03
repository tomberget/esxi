data "template_file" "cilium_config" {
  template = file("${path.root}/modules/cilium/config.yaml")
  vars = {
    
  }
}

resource "helm_release" "cilium" {
  name       = var.chart_name
  namespace  = var.namespace
  repository = "https://helm.cilium.io"
  chart      = var.chart_name
  version    = var.chart_version

  values = [
    data.template_file.cilium_config.rendered
  ]
}
