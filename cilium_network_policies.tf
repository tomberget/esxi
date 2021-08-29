module "cilium_network_policies" {
  source = "github.com/evry-ace/tf-cilium-network-policies.git?ref=v1.0.1"
  count = length(var.namespaces)

  default_cilium_network_policies_enabled = true
  namespace                               = var.namespaces[count.index]

}
