output "azure_rg_name" {
  value = "${azurerm_resource_group.mmz_myproj_rg.name}"
}

output "availibilty_set_id" {
  value = "${azurerm_availability_set.mmz_proj_set.id}"
}