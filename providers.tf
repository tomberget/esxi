terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 1.24.2"
    }
  }
}

provider "vsphere" {
  # user           = var.vsphere_user
  # password       = var.vsphere_password
  # vsphere_server = var.vsphere_server

  # # If you have a self-signed cert
  # allow_unverified_ssl = true

  # Enable debugging
  # client_debug = true
}
