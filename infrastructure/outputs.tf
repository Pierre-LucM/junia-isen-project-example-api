output "acr_login_server" {
  value = module.container_registry.acr_login_server
}

output "app_service_url" {
  value = module.app_service.url
}
