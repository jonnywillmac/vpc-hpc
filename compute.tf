#---------------------------------------------------------
# Create sshkey from file
#---------------------------------------------------------
resource "ibm_is_ssh_key" "sshkey" {
  name       = "hpc-demo"
  public_key = "${file(var.ssh_public_key)}"
}

#---------------------------------------------------------
# Create instances in each subnet in zone1
#---------------------------------------------------------
resource "ibm_is_instance" "main-zone1" {
  count   = "${var.main-count}"
  name    = "${format(var.main-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-main}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.hpc-subnet-zone1.id}"
}

  vpc       = "${ibm_is_vpc.hpcvpc.id}"
  zone      = "${var.zone1}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-main.rendered}"
  
}

#---------------------------------------------------------
# Assign SG to all instances of Main
#---------------------------------------------------------
resource "ibm_is_security_group_network_interface_attachment" "main_ssh_sg_attach" {
  count             = "${ibm_is_instance.main-zone1.count}"
  security_group    = "${ibm_is_security_group.main_ssh_sg.id}"
  network_interface = "${element(ibm_is_instance.main-zone1.*.primary_network_interface.0.id, count.index)}"
}

#---------------------------------------------------------
# Assign floating IPs if needed
#---------------------------------------------------------


# Assign floating IP's to all instances of main
resource "ibm_is_floating_ip" "main-zone1-fip" {
  count     = "${ibm_is_instance.main-zone1.count}"
  name    = "${format(var.main-name, count.index + 1)}-${var.zone1}-fip"
  target  = "${element(ibm_is_instance.main-zone1.*.primary_network_interface.0.id, count.index)}"
}


resource "ibm_is_instance" "hpc-zone1" {
  count   = "${var.hpc-count}"
  name    = "${format(var.hpc-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-hpc}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.hpc-subnet-zone1.id}"
  }

  vpc        = "${ibm_is_vpc.hpcvpc.id}"
  zone       = "${var.zone1}"
  keys       = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data  = "${data.template_cloudinit_config.cloud-init-hpc.rendered}"
  depends_on = ["ibm_is_instance.main-zone1"]
}




