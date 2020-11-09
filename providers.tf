terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1"
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
      version = "~> 2"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
  }
}

provider "kubernetes" {
  load_config_file       = false

}

provider "helm" {
  kubernetes {
    load_config_file       = false
    
  }
}
