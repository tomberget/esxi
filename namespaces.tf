
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "home_assistant" {
  metadata {
    name = "home-assistant"
  }
}

resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_namespace" "pihole" {
  metadata {
    name = "pihole"
  }
}

resource "kubernetes_namespace" "postgres-operator" {
  metadata {
    name = "postgres-operator"
  }
}
