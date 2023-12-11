terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.82"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b3ead447-03dd-4092-ac75-c0cf3cb6c991"
}