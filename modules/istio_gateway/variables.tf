variable "ingress_name" {
  description = "App name used for deployed application"
}

variable "namespace" {
  description = "Namespace where the Gateway and Virtual Service should be deployed."
}

variable "ingress_host" {
  description = "Domain to use"
}

variable "service_name" {
  description = "Name of service, if not the same as the provided ingress_name."
  default     = ""
}

variable "service_port" {
  description = "The service port to connect to, defaults to 80."
  default     = 80
}
