resource "juju_integration" "this" {
  for_each = var.integrations

  model = each.value.model

  application {
    name     = each.value.app1_name
    endpoint = each.value.app1_endpoint
  }

  application {
    name     = each.value.app2_name
    endpoint = each.value.app2_endpoint
  }
}