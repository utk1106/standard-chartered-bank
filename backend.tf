terraform {
  backend "azurerm" {
    resource_group_name  = "scb-tfsate"
    storage_account_name = "scbtesttf"
    container_name       = "scbtesttf"
    key                  = "prod.terraform.tfstate" #key is the file name we want for tfstate file 
  }
}
