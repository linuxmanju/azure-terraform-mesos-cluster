resource "azurerm_virtual_machine" "mmz_myproj_vm" {
     name                  = "vm-${var.prefix}-${count.index}"
     location              = "${var.location}"
     resource_group_name   = "${var.resource_group_name}"
     network_interface_ids = ["${var.azurerm_network_interface[count.index]}"]
     vm_size               = "${var.vm_size}"
     availability_set_id  = "${var.as_id}"

     storage_os_disk {
         name              = "myOsDisk-${count.index}"
         caching           = "ReadWrite"
         create_option     = "FromImage"
         managed_disk_type = "Premium_LRS"
     }

     storage_image_reference {
         publisher = "Canonical"
         offer     = "UbuntuServer"
         sku       = "16.04.0-LTS"
         version   = "latest"
     }

     os_profile {
         computer_name  = "${var.prefix}${count.index}"
         admin_username = "${var.admin_user_name}"
     }

     os_profile_linux_config {
         disable_password_authentication = true
         ssh_keys {
             path     = "/home/${var.admin_user_name}/.ssh/authorized_keys"
             key_data = "${file("${var.public_key}")}"
         }
     }

     count = "${var.repeat_count}"

     tags {
         environment = "${var.tag }"
         vmcount = "${count.index}"
     }
    provisioner "local-exec" {
       command = "echo '${var.public_ip[count.index]}' >> ../ansible/inventory.ip_list"

     }
 }