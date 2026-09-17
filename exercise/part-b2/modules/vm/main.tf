# TODO: move the vsphere_virtual_machine resource from the old root main.tf
# into here, and rewrite every hardcoded/var.* reference to use this
# module's own input variables instead (see variables.tf — every input you
# need is already declared there: var.name, var.resource_pool_id, etc.)
#
# A module's resource block never reads root-level variables directly — it
# only ever sees what's declared in ITS OWN variables.tf.

resource "vsphere_virtual_machine" "vm" {
  # TODO: name             = var.name
  # TODO: resource_pool_id = var.resource_pool_id
  # TODO: datastore_id     = var.datastore_id
  # TODO: folder           = var.folder

  # TODO: num_cpus = var.num_cpus
  # TODO: memory   = var.memory
  # TODO: guest_id = var.guest_id

  network_interface {
    # TODO: network_id = var.network_id
  }

  disk {
    label = "disk0"
    # TODO: size             = var.disk_size
    # TODO: thin_provisioned = var.disk_thin_provisioned
  }

  clone {
    # TODO: template_uuid = var.template_uuid
  }
}
