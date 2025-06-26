# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "cloud_integration" {
  description = "Selection of a cloud integration."
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = can(regex("^(|openstack)$", var.cloud_integration))
    error_message = "Cloud integration must be one of: '', openstack."
  }
}

variable "csi_integration" {
  description = "Selection of a csi integration"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for v in var.csi_integration : can(regex("^(|ceph)$", v))
    ])
    error_message = "Each item in 'csi_integration' must be either '' or 'ceph'."
  }
}

variable "model" {
  description = <<EOT
Juju Model resource definition.

Schema represented by the juju model resource:
  - name: Name of the model
  - cloud: Cloud name
  - region: Region name (optional)
  - config: Configuration map (optional)
  - constraints: Constraints string (optional)
  - credential: Credential name (optional)

https://registry.terraform.io/providers/juju/juju/0.16.0/docs/resources/model
EOT

  type = object({
    name = string
    cloud = object({
      name   = string
      region = optional(string)
    })

    config      = optional(map(any))
    constraints = optional(string)
    credential  = optional(string)
  })

  validation {
    condition = (
      var.model.config == null || alltrue([
        for k, v in var.model.config != null ? var.model.config : {} :
        v == null || can(tostring(v)) || can(tonumber(v)) || can(tobool(v))
      ])
    )
    error_message = "Config must be a map where values are only strings, numbers, or bools."
  }
}

variable "k8s_config" {
  description = "configuration for the k8s charm"
  type = object({
    app_name    = optional(string, "k8s")
    base        = string
    channel     = string
    config      = optional(map(string), {})
    constraints = optional(string)
    resources   = optional(map(string))
    revision    = number
    units       = number
    storage     = optional(map(string))
  })

}

variable "k8s_worker_config" {
  description = "configuration for the k8s_worker charm"
  type = object({
    app_name    = optional(string, "k8s_worker")
    base        = string
    channel     = string
    config      = optional(map(string), {})
    constraints = string
    resources   = optional(map(string))
    revision    = optional(number)
    units       = number
    storage     = optional(map(string))
  })
}

variable "csi_config" {
  description = "configuration for the k8s_worker charm"
  type = object({
    app_name    = optional(string, "ceph_csi")
    base        = string
    channel     = string
    config      = optional(map(string))
    constraints = optional(string)
    resources   = optional(map(string))
    revision    = optional(number)
    units       = optional(number)
    storage     = optional(map(string))
  })
  nullable = true
}
variable "ceph_deployment" {
  description = "whether a ceph deployment exists for this module to relate to, allowed values internal | external | none"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["internal", "external", "none"], var.ceph_deployment)
    error_message = "Ceph deployment must be one of 'internal', 'external', or 'none'."
  }

}
variable "ceph_endpoints" {
  description = ""
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.ceph_deployment == "external" || var.ceph_endpoints != null
    error_message = "ceph endpoints must be provided for external ceph deployments."
  }

}

variable "cos_endpoints" {
  description = "cos endpoints to relate to"
  default     = null
  nullable    = true
}

variable "grafana_agent_config" {
  type = object({
    app_name    = optional(string)
    channel     = optional(string)
    config      = optional(map(any), {})
    constraints = optional(string)
    model_name  = string
    revision    = optional(number)
    units       = optional(number, 1)
  })
}