module "cilium_network_policy" {
  source = "github.com/evry-ace/tf-cilium-network-policies.git?ref=v1.0.2"

  enable_dns_visibility = true

}
