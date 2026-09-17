# ==============================================================================
# Part D — gather the IPs vSphere reports back for our VMs (via VMware
# Tools) and render them into an Ansible inventory file.
#
# The module already waits for VMware Tools to report an IP
# (wait_for_guest_net_timeout in modules/vm/main.tf — go look) and outputs
# it as ip_address. Your job is to collect that across all VM instances and
# render templates/inventory.tmpl with it.
# ==============================================================================

# TODO: write a local_file resource named "ansible_inventory":
#
# resource "local_file" "ansible_inventory" {
#   filename = "${path.module}/inventory.ini"
#
#   content = templatefile("${path.module}/templates/inventory.tmpl", {
#     vms = [
#       for m in module.vm : {
#         name       = m.name
#         ip_address = m.ip_address
#       }
#     ]
#     ansible_user = var.ansible_user
#   })
# }
