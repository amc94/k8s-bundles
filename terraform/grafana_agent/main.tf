module "grafana_agent" {
  count       = length(var.cos_endpoints) > 0 ? 1 : 0
  source      = "git::https://github.com/canonical/grafana-agent-operator//terraform?ref=main"
  model_name  = var.model_name
  app_name    = var.grafana_agent_config.app_name
  channel     = var.grafana_agent_config.channel
  config      = var.grafana_agent_config.config
  constraints = var.grafana_agent_config.constraints
  revision    = var.grafana_agent_config.revision
  units       = var.grafana_agent_config.units
}

module "model_integration" {
  for_each     = var.model_endpoints
  source       = "./model_integrator"
  integrations = local.integrations
}

module "cos_integration" {
  source = "./cmr_integrator"

}