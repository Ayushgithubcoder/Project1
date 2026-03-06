# Outputs for Terraform configuration
# Environment: dev

output "app_service_plan_id" {
  description = "App Service Plan ID"
  value       = module.shared_plan.id
}

output "backend_api_id" {
  description = "Resource ID of backend-api"
  value       = module.backend_api_app.id
}

output "backend_api_url" {
  description = "URL of backend-api"
  value       = module.backend_api_app.default_hostname
}

output "database_connection_string" {
  description = "Connection string for database"
  sensitive   = true
  value       = [for item in module.database_cosmos.connection_strings : item][0]
}

output "database_endpoint" {
  description = "Endpoint for database"
  value       = module.database_cosmos.endpoint
}

output "frontend_app_url" {
  description = "URL of frontend-app"
  value       = module.frontend_app_app.default_host_name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.log_analytics.id
}

output "resource_group_id" {
  description = "Resource group ID"
  value       = module.main_rg.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = module.main_rg.name
}