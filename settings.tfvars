# Local settings
metallb_network_range = "192.168.78.0/27"

# Pihole settings
metallb_pihole_ip_hostnum = 1

# Unifi settings
metallb_unifi_gui_ip_hostnum        = 2
metallb_unifi_controller_ip_hostnum = 3
metallb_unifi_discovery_ip_hostnum  = 4
metallb_unifi_stun_ip_hostnum       = 5

# vSphere settings
datacenter_name = "esxi"
datastore_name  = "kubernetes"
esxi_hosts      = [
    "k8master",
    "k8node1",
    "k8node2",
  ]
