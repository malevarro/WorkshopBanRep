variable "prefix" {
  type = string
  description = "Prefix used for all resources in this example"
  default = "lab-breider"
}

variable "location" {
  type = string
  description = "Azure region to provision resources"
  default = "eastus"
}

variable "k8s_version" {
  type = string
  description = "K8S version for deployment"
  default = "1.27.7"
}