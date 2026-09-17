# TODO: fill in every argument below, using this module's OWN input
# variables (see variables.tf) — not the root module's variables. A
# module's resource block can only ever see what's declared in its own
# variables.tf.

resource "vsphere_virtual_machine" "vm" {
  name             = null # TODO
  resource_pool_id = null # TODO
  datastore_id     = null # TODO
  folder           = null # TODO

  num_cpus = null # TODO
  memory   = null # TODO
  guest_id = null # TODO

  network_interface {
    network_id = null # TODO
  }

  disk {
    label            = "disk0"
    size             = null # TODO
    thin_provisioned = null # TODO
  }

  clone {
    template_uuid = null # TODO
  }
}
