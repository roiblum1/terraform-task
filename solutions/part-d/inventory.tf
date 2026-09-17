# ==============================================================================
# Part D — gather the IPs vSphere reports back for our VMs (via VMware Tools)
# and render them into an Ansible inventory file.
# ==============================================================================

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = templatefile("${path.module}/templates/inventory.tmpl", {
    vms = [
      for m in module.vm : {
        name       = m.name
        ip_address = m.ip_address
      }
    ]
    ansible_user = var.ansible_user
  })
}
