# Local settings
metallb_network_range = "192.168.78.0/27"

# Pihole settings
metallb_pihole_ip_hostnum = 1

# vSphere settings
datacenter_name = "esxi"
datastore_name  = "kubernetes"
esxi_hosts      = [
    "k8master",
    "k8node1",
    "k8node2",
  ]
