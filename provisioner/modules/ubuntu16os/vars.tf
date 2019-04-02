
variable "location" {
  default = "westus"
}

variable "prefix" {
  default = "terratest"
}

variable "tag" {
  default = "Terraform_test"
}

variable "resource_group_name" {
}

variable "azurerm_network_interface" {
  type = "list"
  
}

variable "vm_size" {
  
}


variable "public_ip" {
  type = "list"
  
}

variable "subnetid" {
  
}

variable "repeat_count" {
  
}

variable "as_id" {
  
}

variable "admin_user_name" {

}

variable "public_key" {
  
}

