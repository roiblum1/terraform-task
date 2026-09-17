provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "vm" {
  source = "./modules/vm"
  # TODO: count = var.vm_count
  # This turns module.vm into a LIST of module instances (module.vm[0],
  # module.vm[1], ...) instead of a single one. Every argument below is now
  # evaluated once per instance, with count.index available (0-based).

  # TODO: name = "student-${var.student_id}-tf-vm-${format("%02d", count.index + 1)}"
  # format("%02d", n) pads n to 2 digits: 1 -> "01", 2 -> "02", 3 -> "03".
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = var.datastore_id
  folder           = var.vm_folder
  network_id       = var.network_id

  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  num_cpus  = var.vm_num_cpus
  memory    = var.vm_memory
  disk_size = var.vm_disk_size
}
