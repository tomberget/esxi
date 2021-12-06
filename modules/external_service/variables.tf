variable "service_name" {
  description = "Name of the original service. `external-` will be prefixed to the external service created."
  type        = string
}

variable "service_port" {
  description = "The port you need to hit on the external service. Defaults to 443."
  type        = number
  default     = 443
}

variable "service_namespace" {
  description = "The namespace where you want to create the external service and ingress. Defaults to `default`."
  type        = string
  default     = "default"
}

variable "ingress_path" {
  description = "The default path the ingress should forward to. Defaults to `/`."
  type        = string
  default     = "/"
}

variable "domain" {
  description = "The original domain the service should resolve to."
  type        = string
}

variable "external_domain" {
  description = "The domain forwarding traffic to the ingress."
  type        = string
}
