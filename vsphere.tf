data "vsphere_datacenter" "datacenter" {
  name = "esxi"
}

data "vsphere_host" "esxi_hosts" {
  count         = length(var.esxi_hosts)
  name          = var.esxi_hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_nas_datastore" "datastore" {
  name            = "kubernetes"
  host_system_ids = data.vsphere_host.esxi_hosts.*.id

  type         = "NFS"
  remote_hosts = ["192.168.79.9"]
  remote_path  = "/mnt/default/kubernetes"
  access_mode  = "readWrite"

  lifecycle {
    ignore_changes = [free_space, capacity]
  }
}
