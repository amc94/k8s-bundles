variable "integrations" {
  type = map(object({
    offer_url             = string
    consuming_application = string
    consuming_endpoint    = string
  }))
}