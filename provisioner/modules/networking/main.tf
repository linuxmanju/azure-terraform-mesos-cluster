resource "azurerm_virtual_network" "mmz_myproj_vnet" {
    name                = "mmz_myproj_vnet_${var.prefix}"
    address_space       = ["${var.vnet_address_space}"]
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

    tags {
        environment = "${var.tag}"
    }
}

resource "azurerm_subnet" "mmz_myproj_subnet" {
    name                 = "mmz_myproj_subnet_${var.prefix}"
    resource_group_name  = "${var.resource_group_name}"
    virtual_network_name = "${azurerm_virtual_network.mmz_myproj_vnet.name}"
    address_prefix       = "${cidrsubnet("${var.vnet_address_space}",8,1)}"
}

resource "azurerm_network_security_group" "mmz_myproj_sg" {
    name                = "mmz_myproj_sg_${var.prefix}"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges     = "${var.inbound_ports_to_allow}"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "${var.tag} "
    }
}

resource "azurerm_public_ip" "mmz_myproj_pub" {
    name                         = "mmz_myproj_pub-${var.prefix}-${count.index}"
    location                     = "${var.location}"
    resource_group_name          = "${var.resource_group_name}"
    allocation_method            = "Static"

    count = "${var.repeat_count}"

    tags {
        environment = "${var.tag}"
    }
}
resource "azurerm_network_interface" "mmz_myproj_nic" {
     name                = "nic-${count.index}"
     location            = "${var.location}"
     resource_group_name = "${var.resource_group_name}"
     network_security_group_id = "${azurerm_network_security_group.mmz_myproj_sg.id}"

     ip_configuration {
         name                          = "myNicConfiguration"
         subnet_id                     = "${azurerm_subnet.mmz_myproj_subnet.id}"
         private_ip_address_allocation = "Dynamic"
         public_ip_address_id          = "${element(azurerm_public_ip.mmz_myproj_pub.*.id,count.index)}"
     }

     count = "${var.repeat_count}"

     tags {
         environment = "${var.tag}"
         counter = "${count.index}"
     }
 }
