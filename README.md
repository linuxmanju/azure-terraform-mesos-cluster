Azure provisioner for Mesos, Marathon and zookeeper Cluster setup
=========
Please read the entire Readme.md ( this file ) for usage and samples.
---------


What you get:

- Clustered Mesos, Marathon Zookeeper setup ( minium 4 nodes ) with Docker integration along with Haproxy and automatic service discovery pre configured by the automation.

- A base  re-usable terraform modules to create End to end Infra structure with just 5+ lines of code ( Auto creates Azure Resource group , Vnet, subnets, Availibility group, Security group and all other prerequisites )

- Ansible playbook to deploy a fault tolerant MMZ cluster setup with minimum 4 nodes to X number of nodes ( change the repeatcount in vars.tf ). Post deployment, automated testing of infrastructure by deploying Nginx docker images across the cluster and check service discovery and Load balancing to ensure things work as a part of automation.

- An example inetgration of Terraform ( For provisioning ) and Ansible ( For configuration management ). Simple replacement/reusablity with your own playbook with single line modification null-resource in main.tf if you want to.

- Patched version of marathon-lb ( For service discovery ) and Haproxy ( for load balancing ).. Patched as the current marathon-lb from git doesnt update haproxy config because of some bugs.


Requirements
------------

- A working terraform installation 0.11 and above
- Ansible version 2.7.1 and above
- Azure-cli installed and configured with az login
- Azure subscription which can launch minimum 16 cores ( Quota limit ) ( Default size is Standard_D4s_v3 for MMZ to work properly )
- Linux/Mac with ssh-keys ( default $HOME/.ssh/id_rsa.pub but can be modified in vars.tf) 
- Read and understand what needs to be changed in vars.tf for things to work though default config should work 90 percent of the time.. 
- Some luck and patience :)


Extending and Customizing 
--------------

- If you only want to re-use Terraform for provisioning. Just remove null resource blocks from main.tf and you should be good

The only code you need is.. below to get everything from networking, Resource group to AG, SG, Availibility Set.. etc all the way till N number of azure to get up and running.

Sample code in main.tf..

```
module "ubuntu16os" {
  source = "./modules/ubuntu16os"
  location = "${var.location}"
  prefix = "${var.prefix}"
  tag = "${var.tag}"
  resource_group_name = "${module.base.azure_rg_name}"
  public_ip = "${module.networking.public_ip}"
  subnetid = "${module.networking.subnetid}"
  azurerm_network_interface = "${module.networking.nic_ids}"
  ### Below line is nu,ber of VMs/NICs and Public IPs u get
  repeat_count = "${var.repeatcount}"
  as_id = "${module.base.availibilty_set_id}"
  admin_user_name = "${var.vm_admin_user}"
  public_key = "${var.ssh_pub_key_file}"
  vm_size = "${var.vm_size}"
}
```


- If you only want to use ansible playbook... you know what to do anyway :P


How to use
----------------

```cd provisioner```

Take a look at the vars.tf

```
terraform init
terraform plan
terraform apply
```

wait for provisioning and playbook to finish

fireup the browser and hit http://one-of-the-instance-public-ip:8080/ui you should be greeted with a working marathon UI port 5050 should give u the Mesos UI

To  test nginx deployment.. Go to New Application --> JSON mode and Overwrite the content with the below sample JSON ( Important fields below.. containerport and serviceport)

```
{
  "id": "/nginx",
  "cmd": null,
  "cpus": 1,
  "mem": 128,
  "disk": 0,
  "instances": 4,
  "container": {
    "type": "DOCKER",
    "docker": {
      "forcePullImage": false,
      "image": "nginx",
      "parameters": [],
      "privileged": false
    },
    "volumes": [],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0,
        "labels": {},
        "protocol": "tcp",
        "servicePort": 8181
      }
    ]
  },
  "healthChecks": [
    {
      "gracePeriodSeconds": 300,
      "ignoreHttp1xx": false,
      "intervalSeconds": 60,
      "maxConsecutiveFailures": 3,
      "path": "/",
      "portIndex": 0,
      "protocol": "HTTP",
      "ipProtocol": "IPv4",
      "timeoutSeconds": 20,
      "delaySeconds": 15
    }
  ],
  "labels": {
    "HAPROXY_GROUP": "external"
  },
  "networks": [
    {
      "mode": "container/bridge"
    }
  ],
  "portDefinitions": []
}

```


PS:- Ensure to block port 8080 and 5050 in created security group and allow only your IP
--------


License
-------

BSD

Author Information
------------------

Manjunath KP



TODO:-

Fork to create only Mesos slaves
Add monitoring enhancements
split playbook into multiple roles for better management
