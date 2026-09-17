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

# TODO: replace the resource that used to be here with a call to the vm
# module you just wrote under ./modules/vm. Every input it needs is
# declared in modules/vm/variables.tf — read that file, then fill in each
# blank below. Most come straight from a var.* or data.* already in this
# file; `name` you build yourself, and it must come out to
# "student-<your-id>-tf-vm-01".
module "vm" {
  source = "./modules/vm"

  name             = null # TODO
  resource_pool_id = null # TODO: the compute cluster's resource pool
  datastore_id     = null # TODO
  folder           = null # TODO
  network_id       = null # TODO

  guest_id              = null # TODO: from data.vsphere_virtual_machine.template
  template_uuid         = null # TODO: from data.vsphere_virtual_machine.template
  disk_thin_provisioned = null # TODO: from data.vsphere_virtual_machine.template

  num_cpus  = null # TODO
  memory    = null # TODO
  disk_size = null # TODO
}
