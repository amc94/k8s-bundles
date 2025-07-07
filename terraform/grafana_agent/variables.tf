variable "model_name" {
  type        = string
  description = ""

}

variable "model_endpoints" {
  type = map(object({
    app_name = string
    endpoint = string
  }))
  description = ""
}

variable "cos_endpoints" {
  description = "COS endpoints to integrate with via CMR"
  type        = set(string)
  default     = []
}

variable "grafana_agent_config" {
  type = object({
    app_name    = optional(string)
    channel     = optional(string)
    config      = optional(map(any), {})
    constraints = optional(string)
    revision    = optional(number)
    units       = optional(number, 1)
  })
}