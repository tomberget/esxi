resource "kubernetes_namespace" "nfs_client" {
  metadata {
    name = var.nfs_client_namespace

    labels = {
      "istio-injection"    = "disabled"
      "kiali.io/member-of" = "istio-system"
    }
  }
}

data "template_file" "nfs_client_config" {
  template = file("${path.root}/modules/nfs_client/config.yaml")
  vars = {
  }
}

resource "helm_release" "nfs_client" {
  name       = "nfs-client"
  namespace  = kubernetes_namespace.nfs_client.metadata[0].name
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "nfs-client-provisioner"
  version    = var.nfs_client_chart_version

  values = [
    data.template_file.nfs_client_config.rendered
  ]
}
