resource "azurerm_app_service_plan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = var.kind
  reserved            = var.reserved

  sku {
    tier     = var.sku.tier
    size     = var.sku.size
    capacity = var.sku.capacity
  }

  tags = var.tags
}



