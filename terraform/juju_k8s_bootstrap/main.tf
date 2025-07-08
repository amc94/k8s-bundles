resource "null_resource" "juju_add_k8s_cloud" {
  provisioner "local-exec" {
    command     = <<-EOT
      set -euo pipefail
      echo ">> Checking if K8s cloud exists: ${var.cloud}"
      if juju clouds --format json | grep -q "\"${var.cloud}\":" ; then
        echo ">> Cloud '${var.cloud}' already exists, skipping add-k8s."
        exit 0
      fi
      
      echo ">> Adding K8s cloud"
      KUBECONFIG=${var.kubeconfig} juju add-k8s --cloud ${var.cloud} ${join(" ", local.k8s_args)}
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  provisioner "local-exec" {
    when        = destroy
    command     = <<-EOT
      set -euo pipefail
      echo ">> Removing K8s cloud '${self.triggers.cloud_name}'"
      if juju clouds --format json | grep -q "\"${self.triggers.cloud_name}\":" ; then
        echo ">> Found cloud, removing..."
        juju remove-cloud "${self.triggers.cloud_name}" || true
      else
        echo ">> Cloud '${self.triggers.cloud_name}' not found, skipping remove."
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  triggers = {
    cloud_name  = var.cloud
    kubeconfig  = var.kubeconfig
    k8s_hash    = sha256(join(",", local.k8s_args))
  }
}


resource "null_resource" "juju_bootstrap_controller" {
  
  provisioner "local-exec" {
    command     = <<-EOT
      set -euo pipefail
      echo ">> Checking if controller exists: ${var.controller_name}"
      if juju controllers --format json | grep -q "\"${var.controller_name}\":" ; then
        echo ">> Controller '${var.controller_name}' already exists, skipping bootstrap."
        exit 0
      fi
      

      echo ">> Bootstrapping controller '${var.controller_name}'"
      juju bootstrap ${var.cloud} ${var.controller_name} ${join(" ", local.bootstrap_args)}
      
      if [[ "${var.ha_configuration}" == "true" ]]; then
        echo ">> Enabling HA with ${var.number_of_ha_units} units"
        juju enable-ha -n ${var.number_of_ha_units} ${var.bootstrap_options.bootstrap_constraints != null ? "--constraints \"${var.bootstrap_options.bootstrap_constraints}\"" : ""}
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  provisioner "local-exec" {
    when        = destroy
    command     = <<-EOT
      set -euo pipefail
      echo ">> Destroying Juju controller '${self.triggers.controller_name}'"
      if juju controllers --format json | grep -q "\"${self.triggers.controller_name}\":" ; then
        echo ">> Found controller, destroying..."
        juju destroy-controller --yes --destroy-all-models --client "${self.triggers.controller_name}" || true
      else
        echo ">> Controller '${self.triggers.controller_name}' not found, skipping destroy."
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  triggers = {
    controller_name = var.controller_name
    cloud_name      = var.cloud
    kubeconfig      = var.kubeconfig
    enable_ha       = var.ha_configuration
    bootstrap_hash  = sha256(join(",", local.bootstrap_args))
    k8s_hash        = sha256(join(",", local.k8s_args))
  }
}


resource "null_resource" "juju_default_model_config" {
  depends_on = [null_resource.juju_bootstrap_controller]
  count      = var.model_defaults != null ? 1 : 0
  
  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail
      echo ">> Configuring Juju model defaults"
      juju model-defaults ${join(" ", local.model_defaults_args)}
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  
  triggers = {
    model_defaults_hash = var.model_defaults != null ? sha256(jsonencode(var.model_defaults)) : ""
  }
}