#---------------------------------------------------------
# Get resource_group id
#---------------------------------------------------------

data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

#---------------------------------------------------------
# Create new VPC
#---------------------------------------------------------

resource "ibm_is_vpc" "hpcvpc" {
  name                = "${var.vpc-name}"
  resource_group      = "${data.ibm_resource_group.group.id}"
#  default_network_acl = "${ibm_is_network_acl.default_acl.id}"
}

#---------------------------------------------------------
# Create new address prefixes in VPC
#---------------------------------------------------------
resource "ibm_is_vpc_address_prefix" "prefix1" {
  name = "zone1-cidr-1"
  vpc  = "${ibm_is_vpc.hpcvpc.id}"
  zone = "${var.zone1}"
  cidr = "${var.address-prefix-1}"
}

#---------------------------------------------------------
# Create new security group to allow SSH
#---------------------------------------------------------
resource "ibm_is_security_group" "main_ssh_sg" {
    vpc = "${ibm_is_vpc.hpcvpc.id}"
    resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_security_group_rule" "main_ssh_sg_rule_ssh" {
    group = "${ibm_is_security_group.main_ssh_sg.id}"
    direction = "inbound"
    remote = "0.0.0.0/0"
    tcp = {
      port_min = 22
      port_max = 22
    }
}
resource "ibm_is_security_group_rule" "main_ssh_sg_rule_outall" {
    group = "${ibm_is_security_group.main_ssh_sg.id}"
    direction = "outbound"
    remote = "0.0.0.0/0"
    
}


#---------------------------------------------------------
## Create Webapp & Db Subnets in Zone1
#---------------------------------------------------------
resource "ibm_is_subnet" "hpc-subnet-zone1" {
  name            = "${var.vpc-name}-${var.zone1}-hpc"
  vpc             = "${ibm_is_vpc.hpcvpc.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.hpc-subnet-zone-1}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}
