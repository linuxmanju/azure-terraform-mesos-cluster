resource "azurerm_resource_group" "mmz_myproj_rg" {
  name = "testrm_${var.prefix}"
  location = "${var.location}"

  tags {
    environment = "${var.tag}"
  }
  }

resource "azurerm_availability_set" "mmz_proj_set" {
  name                = "testas_${var.prefix}"
  location            = "${azurerm_resource_group.mmz_myproj_rg.location}"
  resource_group_name = "${azurerm_resource_group.mmz_myproj_rg.name}"
  managed = "true"

  tags = {
    environment = "${var.tag}"
  }
}