data "template_cloudinit_config" "cloud-init-hpc" {
  base64_encode = false
  gzip          = false

  part {
    content = <<EOF
#cloud-config
package-update: true
package_upgrade: true
packages:
 - tcsh
 - nfs-utils
 - bzip2
 - redhat-lsb

runcmd:
- mkdir /softwaremount
- [ mount.nfs, 172.21.2.9:/softwaremount, /softwaremount ]
- /softwaremount/installscript.sh

 EOF
  }
}
