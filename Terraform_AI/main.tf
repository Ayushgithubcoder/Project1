# Terraform configuration generated from Resource Plan
# Environment: dev
# Generated from deterministic resource plan (Phase 2)

terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateproject1xyz"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# ========================================
# Phase: 1 Foundation
# ========================================

# Module: rg_main (azurerm_resource_group)
module "main_rg" {
  source = "./modules/azure-resource-group"

  location = var.location
  name     = "project-rg"
}

# Module: log_analytics (azurerm_log_analytics_workspace)
module "log_analytics" {
  source = "./modules/azure-log-analytics-workspace"

  location            = var.location
  name                = "project-log"
  resource_group_name = module.main_rg.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}

# ========================================
# Phase: 2 Shared Infrastructure
# ========================================

# Module: app_service_plan (azurerm_service_plan)
module "shared_plan" {
  source = "./modules/azure-app-service-plan"

  kind                = "Linux"
  location            = var.location
  name                = "project-infrastructure"
  resource_group_name = module.main_rg.name
  sku = {
    tier     = "Standard"
    size     = "S1"
    capacity = 1
  }
  tags = var.tags
}

# ========================================
# Phase: 3 Data
# ========================================

# Module: database_account (azurerm_cosmosdb_account)
module "database_cosmos" {
  source = "./modules/azure-cosmosdb-account"

  consistency_policy              = var.consistency_policy
  enable_automatic_failover       = true
  enable_multiple_write_locations = false
  geo_location                    = var.geo_location
  kind                            = "MongoDB"
  location                        = var.location
  name                            = "project-cosmos-0ee8de"
  offer_type                      = "Standard"
  resource_group_name             = module.main_rg.name
  tags                            = var.tags
}

# ========================================
# Phase: 4 Compute
# ========================================

# Module: backend-api_app (azurerm_linux_web_app)
module "backend_api_app" {
  source = "./modules/azure-linux-web-app"

  app_settings = {
  }
  enable_system_identity = true
  https_only             = true
  location               = var.location
  name                   = "project-backend-3e77da"
  resource_group_name    = module.main_rg.name
  runtime_stack = {
    language = "node"
    version  = var.backend_api_node_version
  }
  service_plan_id = module.shared_plan.id
  tags            = var.tags
}

# Module: frontend-app_app (azurerm_static_site)
module "frontend_app_app" {
  source = "./modules/azure-static-site"

  location            = var.location
  name                = "project-frontend"
  resource_group_name = module.main_rg.name
  sku_size            = "Free"
  sku_tier            = "Free"
  tags                = var.tags
}
