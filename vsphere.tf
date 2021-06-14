data "vsphere_datacenter" "datacenter" {
  name = "esxi"
}

data "vsphere_datastore" "kubernetes" {
  name          = "kubernetes"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
