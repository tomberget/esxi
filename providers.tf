terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "~> 0.2"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.0.1"
    }
  }
}

provider "kubernetes" {

}

provider "helm" {
  kubernetes {

  }
}

provider "kubernetes-alpha" {

}

provider "random" {}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}