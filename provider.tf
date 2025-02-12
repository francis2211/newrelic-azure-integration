terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "3.1.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = var.client_id 
  client_secret   = var.client_secret 
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id 
}

# Configure the New Relic provider
provider "newrelic" {
  account_id = var.account_id # Newrelic Account
  api_key = var.api_key # usually prefixed with 'NRAK'
  region = var.region # default "US"                    
}
