data "template_cloudinit_config" "cloud-init-main" {
  base64_encode = false
  gzip          = false

  part {
    content = <<EOF
#cloud-config

package-update: true
package_upgrade: true

write_files:
- encoding: b64
  content: L3NvZnR3YXJlbW91bnQgICAgICAgICoocixzeW5jLG5vX3Jvb3Rfc3F1YXNoLG5vX3N1YnRyZWVfY2hlY2spCg==
  owner: root:root
  path: /etc/exports
  permissions: '0644'
runcmd:
- mkdir /softwaremount
- [ wget, "https://jhpc.s3.eu-de.cloud-object-storage.appdomain.cloud/VPSolution2018r0u0_MasterLinux_180806.iso?AWSAccessKeyId=adbc9e8c725e4421a6f2ce204fc98985&Expires=1576093629&Signature=BC7M7L6I8TL%2B4zWAjKVlNcrRZfM%3D", -O, /softwaremount/VPSolution2018r0u0_MasterLinux_180806.iso ]
- [ wget, "https://jhpc.s3.eu-de.cloud-object-storage.appdomain.cloud/VPSolution-2018.01_DMP%20SMP-Solvers_Linux-Intel64.tar.bz2?AWSAccessKeyId=adbc9e8c725e4421a6f2ce204fc98985&Expires=1576097156&Signature=cdy%2BJOVqCkSfBr1qOtwwyvYBP78%3D", -O, /softwaremount/VPSolution-2018.01_DMP%20SMP-Solvers_Linux-Intel64.tar.bz2 ]
- [ systemctl, enable, nfs-server.service ]
- [ systemctl, start, nfs-server.service ]

 EOF
  }
}
