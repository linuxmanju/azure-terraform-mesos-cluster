output "vmid" {
  value = "${azurerm_virtual_machine.mmz_myproj_vm.*.id}"
}
