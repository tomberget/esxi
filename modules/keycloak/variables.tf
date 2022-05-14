variable "name" {
  type        = string
  default     = "keycloak"
  description = "Name of the helm release"
}

variable "namespace" {
  type        = string
  description = "It specify the Keycloak namespace where Keycloak will deployed"
}

variable "chart_version" {
  type        = string
  description = "This will specify the Keycloak chart version"
}

variable "ingress_hostname" {
  type        = string
  description = "This will specify the ingress url"
}

variable "external_database_host" {

}

variable "external_database_username" {

}

variable "external_database_password" {

}

variable "ha_enabled" {

}
