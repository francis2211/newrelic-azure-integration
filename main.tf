data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "example" {}

resource "azuread_application" "example" {
  display_name     = "newrelic-integration"
  owners           = [data.azuread_client_config.current.object_id]
  web  {
  redirect_uris = ["https://newrelic.com/"]
  }
}

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
  owners                       = [data.azuread_client_config.current.object_id]
  depends_on = [azuread_application.example]
}

resource "azurerm_role_assignment" "app_contributor" {
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.example.object_id
  scope                = data.azurerm_subscription.current.id
}

resource "time_rotating" "example" {
    rotation_days = 7
}

resource "azuread_application_password" "example" {
  display_name = "newrelic-integration"
  application_id = azuread_application.example.id
  rotate_when_changed = {
    rotation = time_rotating.example.id
  }
  depends_on = [time_rotating.example]
}

output "subscription_id" {
  description = "Subcription_ID"
  value       = data.azurerm_subscription.current.subscription_id
}
output "application_id" {
  description = "Client Secret"
  value       = azuread_application.example.client_id #azuread_application.example.id
}
output "client_secret" {
  description = "Client Secret"
  value       = nonsensitive(azuread_application_password.example.value)
}

#### NEWRELIC CONFIG ####
resource "newrelic_cloud_azure_link_account" "foo"{
  account_id = var.account_id  #"the New Relic account ID where you want to link the Azure account"
  application_id =  azuread_application.example.client_id 
  client_secret = nonsensitive(azuread_application_password.example.value) 
  subscription_id = data.azurerm_subscription.current.subscription_id
  tenant_id = var.tenant_id 
  name  = "newrelic-azure"
  depends_on = [azurerm_role_assignment.app_contributor]
}

resource "newrelic_cloud_azure_integrations" "foo" {
  linked_account_id = newrelic_cloud_azure_link_account.foo.id
  account_id = var.account_id 

  monitor {
    metrics_polling_interval = 60
    resource_types           = ["microsoft.apimanagement/service"]
  }
}
