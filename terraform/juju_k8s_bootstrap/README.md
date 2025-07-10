## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.juju_add_k8s_cloud](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.juju_bootstrap_controller](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.juju_default_model_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_options"></a> [bootstrap\_options](#input\_bootstrap\_options) | Configuration object for Juju bootstrap command flags | <pre>object({<br/>    # Authentication and browser options<br/>    no_browser_login = optional(bool)<br/><br/>    # Model and controller configuration<br/>    default_model = optional(string, "")<br/><br/>    # Agent and version options<br/>    agent_version = optional(string)<br/>    auto_upgrade  = optional(bool)<br/>    build_agent   = optional(bool)<br/><br/>    # Bootstrap machine configuration<br/>    bootstrap_base        = optional(string)<br/>    bootstrap_constraints = optional(string)<br/>    bootstrap_image       = optional(string)<br/><br/>    # Cloud and region options<br/>    clouds  = optional(bool)<br/>    regions = optional(string)<br/><br/>    # Configuration files and options<br/>    config        = optional(string)<br/>    constraints   = optional(list(string))<br/>    model_default = optional(string)<br/><br/>    # Controller charm options<br/>    controller_charm_channel = optional(string)<br/>    controller_charm_path    = optional(string)<br/><br/>    # Credentials and authentication<br/>    credential = optional(string)<br/><br/>    # Database options<br/>    db_snap             = optional(string)<br/>    db_snap_assert_file = optional(string)<br/><br/>    # Error handling and validation<br/>    force       = optional(bool)<br/>    keep_broken = optional(bool)<br/><br/>    # Metadata and sources<br/>    metadata_source = optional(string)<br/><br/>    # Controller switching<br/>    no_switch = optional(bool)<br/><br/>    # Storage configuration<br/>    storage_pool = optional(string)<br/><br/>    # Placement options<br/>    to = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | cloud to boostrap | `string` | n/a | yes |
| <a name="input_controller_name"></a> [controller\_name](#input\_controller\_name) | name of the controller | `string` | n/a | yes |
| <a name="input_ha_configuration"></a> [ha\_configuration](#input\_ha\_configuration) | enable ha | `bool` | `false` | no |
| <a name="input_k8s_options"></a> [k8s\_options](#input\_k8s\_options) | n/a | <pre>object({<br/>    client       = optional(bool, false)<br/>    cluster_name = optional(string)<br/>    context_name = optional(string)<br/>    credential   = optional(string)<br/>    region       = optional(string)<br/>    skip_storage = optional(bool, false)<br/>    storage      = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_kubeconfig"></a> [kubeconfig](#input\_kubeconfig) | Path to kubeconfig | `string` | n/a | yes |
| <a name="input_model_defaults"></a> [model\_defaults](#input\_model\_defaults) | n/a | <pre>object({<br/>    # Authentication and browser options<br/>    no_browser_login        = optional(bool)<br/>    file                    = optional(string)<br/>    ignore_read_only_fields = optional(bool)<br/>    out_file                = optional(string)<br/>    region                  = optional(string)<br/>    reset                   = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_number_of_ha_units"></a> [number\_of\_ha\_units](#input\_number\_of\_ha\_units) | how many units for HA | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controller_name"></a> [controller\_name](#output\_controller\_name) | name of the deployed controller |
