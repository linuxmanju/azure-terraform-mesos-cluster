module "ubuntu16os" {
  source = "./modules/ubuntu16os"
  location = "${var.location}"
  prefix = "${var.prefix}"
  tag = "${var.tag}"
  resource_group_name = "${module.base.azure_rg_name}"
  public_ip = "${module.networking.public_ip}"
  subnetid = "${module.networking.subnetid}"
  azurerm_network_interface = "${module.networking.nic_ids}"
  repeat_count = "${var.repeatcount}"
  as_id = "${module.base.availibilty_set_id}"
  admin_user_name = "${var.vm_admin_user}"
  public_key = "${var.ssh_pub_key_file}"
  vm_size = "${var.vm_size}"
}

resource "null_resource" "ansible-all" {
    
    depends_on = ["module.ubuntu16os"]

    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u '${var.vm_admin_user}' -i ../ansible/inventory.ip_list ../ansible/site.yml"
    }
  
}

resource "null_resource" "cleanup-inv" {

  provisioner "local-exec" {
    when = "destroy"
    command = "rm -f ../ansible/inventory.ip_list"

  }
  
}
