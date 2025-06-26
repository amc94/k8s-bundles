variable "integrations" {
  type = map(object({
    model         = string
    app1_name     = string
    app1_endpoint = string
    app2_name     = string
    app2_endpoint = string
  }))
}