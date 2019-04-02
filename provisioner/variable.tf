variable "location" {
  default = "westus"
}

variable "prefix" {
  default = "terraform"
}

variable "tag" {
  default = "mmz_myproj"
}

variable "repeatcount" {
    description = " change below to match the number of instances that you launch"
    default = 4
}

variable "open_tcp_ports" {
    type = "list"
    default = [22,80,5050,8080]
  
}

variable "vm_admin_user" {
    default = "sysadmin"
  
}

variable "ssh_pub_key_file" {
    default = "~/.ssh/id_rsa.pub"
  
}

variable "vm_size" {

  default = "Standard_D4s_v3"
  
}



## end


