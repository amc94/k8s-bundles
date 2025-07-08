data "juju_offer" "remote" {
  for_each = var.integrations

  url = each.value.url
}

resource "juju_integration" "this" {
  for_each = var.integrations

  model = each.value.integration_model

  application {
    name     = each.value.consuming_application
    endpoint = each.value.consuming_endpoint
  }

  application {
    offer_url = data.juju_offer.remote[each.key].url
  }
}
