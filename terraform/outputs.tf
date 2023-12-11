output "aks_id" {
  value = azurerm_kubernetes_cluster.AKSBreider.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.AKSBreider.fqdn
}

output "aks_node_group" {
  value = azurerm_kubernetes_cluster.AKSBreider.node_resource_group
}

output "resource_group_name" {
  value = azurerm_resource_group.RG-AKS.name
}

/* output "kube_config" {
  value = azurerm_kubernetes_cluster.AKSBreider.kube_config_raw
  sensitive = true
}

output "client_key" {
  value = azurerm_kubernetes_cluster.AKSBreider.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.AKSBreider.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.AKSBreider.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.AKSBreider.kube_config.0.host
  sensitive = true
} */