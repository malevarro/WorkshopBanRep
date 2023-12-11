resource "azurerm_resource_group" "RG-AKS" {
  name = "${var.prefix}-k8s-resources"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "AKSBreider" {
  name = "${var.prefix}-k8s"
  location = azurerm_resource_group.RG-AKS.location
  resource_group_name = azurerm_resource_group.RG-AKS.name
  kubernetes_version = var.k8s_version
  dns_prefix = "${var.prefix}-k8s"

  default_node_pool {
    name = "default"
    node_count = 2
    vm_size = "Standard_DS2_v2"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin = "kubenet"
  }

  tags = {
    Environment = "Labs"
    CreatedBy = "Breider Santacruz"
  }

}