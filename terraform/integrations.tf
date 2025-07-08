# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

data "juju_model" "this" {
  name = var.model_name
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

resource "juju_integration" "ceph_k8s_info" {
  count = var.ceph_deployment != "none" ? 1 : 0
  model = data.juju_model.this.name
  application {
    name     = module.k8s.app_name
    endpoint = module.k8s.provides.ceph_k8s_info
  }
  application {
    name     = module.ceph_csi.0.app_name
    endpoint = module.ceph_csi.0.requires.kubernetes_info
  }
}


resource "juju_integration" "ceph_client" {
  count = var.ceph_deployment == "internal" ? 1 : 0
  model = data.juju_model.this.name
  application {
    name     = var.ceph_mon.app_name
    endpoint = "client"
  }
  application {
    name     = module.ceph_csi.app_name
    endpoint = module.ceph_csi.requires.ceph_client
  }
}

module "ceph_external_integration" {
  count  = var.ceph_deployment == "external" ? 1 : 0
  source = "./cmr_integrator"
  integrations = {
    ceph_client = {
      offer_url             = var.ceph_endpoints
      consuming_application = module.ceph_csi.0.app_name
      consuming_endpoint    = module.ceph_csi.0.requires.ceph_client
    }
  }
}