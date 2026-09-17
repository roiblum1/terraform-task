# ==============================================================================
# Part D — gather the IPs vSphere reports back for our VMs (via VMware
# Tools) and render them into an Ansible inventory file.
#
# The module already waits for VMware Tools to report an IP
# (wait_for_guest_net_timeout in modules/vm/main.tf — go look) and outputs
# it as ip_address. Your job: collect that across all VM instances and
# render templates/inventory.tmpl with it, writing the result to
# inventory.ini using the hashicorp/local provider's local_file resource.
# ==============================================================================

resource "local_file" "ansible_inventory" {
  filename = null # TODO: write it next to this file, named inventory.ini
  # (hint: path.module gives you this module's own directory)

  content = null # TODO: render templates/inventory.tmpl with templatefile().
  # It needs two things: a `vms` list where each entry has a `name` and an
  # `ip_address` (build this from module.vm with a `for` expression — see
  # CHEATSHEET.md for the syntax), and `ansible_user`.
}
