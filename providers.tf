terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.0.1"
    }
  }

  required_version = "~> 1.1"
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
}

provider "helm" {
  kubernetes {

  }
}

provider "random" {}
