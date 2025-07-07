locals {
  integrations = {
    for key, value in var.model_endpoints : key => {
      model         = var.model_name
      app1_name     = value.app_name
      app1_endpoint = value.endpoint
      app2_name     = var.grafana_agent_config.app_name
      app2_endpoint = "grafana_agent"
    }
  }

  cmr_integrations = {
    for url in var.cos_endpoints : url => {
      offer_url             = url
      consuming_application = var.grafana_agent_config.app_name
      consuming_endpoint    = "cos-agent"
    }
  }
}
