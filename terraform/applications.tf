# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  _k8s_keys      = keys(module.k8s_config.config)
  _k8s_key_count = length(local._k8s_keys)
  k8s_config     = local._k8s_key_count == 1 ? module.k8s_config.config[local._k8s_keys[0]] : null
}

resource "null_resource" "validate_unique_k8s" {
  count = local._k8s_key_count == 1 ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      >&2 echo "ERROR: Expected exactly 1 k8s entry, but got ${local._k8s_keys}"
      exit 1
    EOT
  }
}

output "debug" {
  value = {
    k8s_config = var.k8s_config
    ceph       = [for ceph in module.ceph : ceph.debug]
    openstack  = [for openstack in module.openstack : openstack.debug]
  }
}

module "k8s" {
  source   = "git::https://github.com/canonical/k8s-operator//charms/worker/k8s/terraform?ref=main"
  app_name = var.k8s_config.app_name
  channel  = var.k8s_config.channel
  config = merge(
    (
      length(keys(module.k8s_worker_config.config)) > 0 ?
      # if there are workers, control-planes are tainted with NoSchedule
      { "bootstrap-node-taints" : "node-role.kubernetes.io/control-plane:NoSchedule" } :
      # if there are no-workers, control-planes cannot be tainted
      {}
    ),
    var.k8s_config.config,
  )
  constraints = var.k8s_config.constraints
  model       = resource.juju_model.this.name
  resources   = var.k8s_config.resources
  revision    = var.k8s_config.revision
  base        = var.k8s_config.base
  units       = var.k8s_config.units
}

module "k8s_worker" {
  source      = "git::https://github.com/canonical/k8s-operator//charms/worker/terraform?ref=main"
  for_each    = module.k8s_worker_config.config
  app_name    = each.value.app_name
  base        = coalesce(each.value.base, local.k8s_config.base)
  constraints = coalesce(each.value.constraints, local.k8s_config.constraints)
  channel     = coalesce(each.value.channel, local.k8s_config.channel)
  config      = each.value.config
  model       = resource.juju_model.this.name
  resources   = each.value.resources
  revision    = each.value.revision
  units       = each.value.units
}

module "openstack" {
  count  = var.cloud_integration == "openstack" ? 1 : 0
  source = "./openstack"
  model  = resource.juju_model.this.name
  k8s = {
    app_name    = module.k8s.app_name
    base        = var.k8s_config.base
    constraints = var.k8s_config.constraints
    channel     = var.k8s_config.channel
    provides    = module.k8s.provides
    requires    = module.k8s.requires
  }
}

module "ceph_csi" {
  count       = length(var.csi_integration) > 0 ? 1 : 0
  source      = "git::https://github.com/charmed-kubernetes/ceph-csi-operator//terraform?ref=main"
  model       = var.model
  app_name    = var.csi_config.app_name
  base        = var.csi_config.base
  constraints = var.csi_config.constraints
  channel     = coalesce(var.csi_config.channel, var.k8s.channel)

  config   = coalesce(var.csi_config.config, {})
  revision = var.csi_config.revision
}

