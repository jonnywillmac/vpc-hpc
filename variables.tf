#---------------------------------------------------------
# MODIFY VARIABLES AS NEEDED
#---------------------------------------------------------
#---------------------------------------------------------

#---------------------------------------------------------
## DEFINE VPC
#---------------------------------------------------------
variable "vpc-name" {
  default = "vpc-hpc"
}

variable "resource_group" {
  default = "VPCTesting"
}

variable "cis_resource_group" {
  default = "default"
}

#---------------------------------------------------------
## DEFINE Zones
#---------------------------------------------------------
variable "zone1" {
  default = "us-south-2"
}

variable "zone2" {
  default = "us-south-3"
}

#---------------------------------------------------------
## DEFINE CIDR Blocks to be used in each zone
#---------------------------------------------------------
variable "address-prefix-vpc" {
  default = "172.21.0.0/20"
}

variable "address-prefix-1" {
  default = "172.21.0.0/21"
}

variable "address-prefix-2" {
  default = "172.21.8.0/21"
}

#---------------------------------------------------------
## DEFINE subnets for zone 1
#---------------------------------------------------------

variable "hpc-subnet-zone-1" {
  default = "172.21.2.0/24"
}

#---------------------------------------------------------
## DEFINE DNS
#---------------------------------------------------------
variable "domain" {
  default = "mydomain.com"
}

variable "cis_instance_name" {
  default = "mydomain.com"
}

variable "dns_name" {
  default = "www."
}

#---------------------------------------------------------
## DEFINE sshkey to be used for compute instances
#---------------------------------------------------------
variable "ssh_public_key" {
  default = "here.pub"
}

#---------------------------------------------------------
## DEFINE OS image to be used for compute instances
#---------------------------------------------------------

#image = centos-7-amd64(7.x - Minimal Install)
variable "image" {
  default = "r006-e0039ab2-fcc8-11e9-8a36-6ffb6501dd33"
}

#---------------------------------------------------------
## DEFINE main compute instance profile & quantity
#---------------------------------------------------------
variable "profile-main" {
  default = "bx2-2x8"
}

variable "main-name" {
  default = "main%02d"
}

variable "main-count" {
  default = 1
}

#---------------------------------------------------------
## DEFINE HPC tier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-hpc" {
  default = "bx2-32x128"
}

variable "hpc-name" {
  default = "hpc%02d"
}

variable "hpc-count" {
  default = 0
}
