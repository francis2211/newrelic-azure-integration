### Setup Terraform App to Interact with Azure

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}
  
### NewRelic Setup

variable "account_id" {
  type = string
}

variable "api_key" {
  type = string
}

variable "region" {
  type = string
  default = "US"
}
