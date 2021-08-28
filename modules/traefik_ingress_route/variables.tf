variable "name" {
  description = "Name used for IngressRoute"
  type        = string
}

variable "namespace" {
  description = "The namespace the IngressRoute will use"
  type        = string
}

variable "route_kind" {
  description = "Route kind. Most likely Rule"
  type        = string
  default     = "Rule"
}

variable "route_match" {
  description = "Route matching"
  type        = string
}

variable "service_name" {
  description = "Name used for service name"
  type        = string
}

variable "service_kind" {
  description = "Kind of service"
  type        = string
  default     = "Service"
}

variable "service_pass_host_header" {
  description = "Pass host header"
  type        = bool
  default     = true
}

variable "service_scheme" {
  description = "Scheme used"
  type        = string
  default     = "http"
}

variable "service_port" {
  description = "Named port, or port number"
  type        = string
  default     = "http"
}

variable "service_responseForwarding_flushInterval" {
  description = "The flush interval of the response forwarding"
  type        = string
  default     = "1ms"
}

variable "service_strategy" {
  description = "Type of strategy for load balancing"
  type        = string
  default     = "RoundRobin"
}
