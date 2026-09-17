resource "vsphere_virtual_machine" "vm" {
  name             = var.name
  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id
  folder           = var.folder

  num_cpus = var.num_cpus
  memory   = var.memory
  guest_id = var.guest_id

  # DHCP is on for this EPG, so the IP isn't known until the VM boots and
  # VMware Tools reports it back. Wait up to 5 minutes for that to happen so
  # `default_ip_address` below is populated when this resource finishes
  # applying, instead of coming back empty.
  wait_for_guest_net_timeout  = 5
  wait_for_guest_net_routable = false

  network_interface {
    network_id = var.network_id
  }

  disk {
    label            = "disk0"
    size             = var.disk_size
    thin_provisioned = var.disk_thin_provisioned
  }

  clone {
    template_uuid = var.template_uuid
  }
}
