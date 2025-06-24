# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

data "juju_model" "this" {
  name = var.model.name
}

resource "juju_integration" "k8s_cluster_integration" {
  model    = data.juju_model.this.name
  for_each = module.k8s_worker
  application {
    name     = module.k8s.app_name
    endpoint = module.k8s.provides.k8s_cluster
  }
  application {
    name     = each.value.app_name
    endpoint = each.value.requires.cluster
  }
}

resource "juju_integration" "k8s_containerd" {
  model    = data.juju_model.this.name
  for_each = module.k8s_worker
  application {
    name     = module.k8s.app_name
    endpoint = module.k8s.provides.containerd
  }
  application {
    name     = each.value.app_name
    endpoint = each.value.requires.containerd
  }
}

resource "juju_integration" "k8s_cos_worker_tokens" {
  model    = data.juju_model.this.name
  for_each = module.k8s_worker
  application {
    name     = module.k8s.app_name
    endpoint = module.k8s.provides.cos_worker_tokens
  }
  application {
    name     = each.value.app_name
    endpoint = each.value.requires.cos_tokens
  }
}
