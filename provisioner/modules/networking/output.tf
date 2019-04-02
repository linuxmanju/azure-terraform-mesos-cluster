
output "subnetid" {
  value = "${azurerm_subnet.mmz_myproj_subnet.id}"
}

output "sg_id" {
  value = "${azurerm_network_security_group.mmz_myproj_sg.id}"
}

output "public_ip" {
  value = "${azurerm_public_ip.mmz_myproj_pub.*.ip_address}"
}

output "nic_ids" {
  value = "${azurerm_network_interface.mmz_myproj_nic.*.id}"
}
