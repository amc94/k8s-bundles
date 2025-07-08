#This should be a credential stored in vault
variable "kubeconfig" {
  type        = string
  description = "Path to kubeconfig"
}

variable "controller_name" {
  type        = string
  description = "name of the controller"
}

variable "cloud" {
  type        = string
  description = "cloud to boostrap"
}

variable "ha_configuration" {
  type        = bool
  description = "enable ha"
}

variable "number_of_ha_units" {
  type        = number
  description = "how many units for HA"
  default     = 3
}

variable "model_defaults" {
  type = object({
    # Authentication and browser options
    no_browser_login        = optional(bool)
    file                    = optional(string)
    ignore_read_only_fields = optional(bool)
    out_file                = optional(string)
    region                  = optional(string)
    reset                   = optional(string)
  })
  default = null
}

variable "k8s-options" {
  type = object({
    client       = optional(bool, false)
    cluster_name = optional(string)
    context_name = optional(string)
    credential   = optional(string)
    region       = optional(string)
    skip_storage = optional(bool, false)
    storage      = optional(string)
  })

  default = {}
}

variable "bootstrap_options" {
  description = "Configuration object for Juju bootstrap command flags"
  type = object({
    # Authentication and browser options
    no_browser_login = optional(bool)

    # Model and controller configuration
    default_model = optional(string, "")

    # Agent and version options
    agent_version = optional(string)
    auto_upgrade  = optional(bool)
    build_agent   = optional(bool)

    # Bootstrap machine configuration
    bootstrap_base        = optional(string)
    bootstrap_constraints = optional(string)
    bootstrap_image       = optional(string)

    # Cloud and region options
    clouds  = optional(bool)
    regions = optional(string)

    # Configuration files and options
    config        = optional(string)
    constraints   = optional(list(string))
    model_default = optional(string)

    # Controller charm options
    controller_charm_channel = optional(string)
    controller_charm_path    = optional(string)

    # Credentials and authentication
    credential = optional(string)

    # Database options
    db_snap             = optional(string)
    db_snap_assert_file = optional(string)

    # Error handling and validation
    force       = optional(bool)
    keep_broken = optional(bool)

    # Metadata and sources
    metadata_source = optional(string)

    # Controller switching
    no_switch = optional(bool)

    # Storage configuration
    storage_pool = optional(string)

    # Placement options
    to = optional(string)
  })

}