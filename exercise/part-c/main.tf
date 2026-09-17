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
  count  = null # TODO: how many VMs? (see the variable you just added)
  # count turns module.vm into a LIST of module instances (module.vm[0],
  # module.vm[1], ...) instead of a single one. Every argument below is now
  # evaluated once per instance, with count.index available (0-based).

  name = null # TODO: build "student-<id>-tf-vm-01" / "-02" / "-03" here.
  # You'll need string interpolation plus Terraform's format() function to
  # zero-pad count.index (0-based!) into a 2-digit suffix. See CHEATSHEET.md
  # for what format("%02d", n) does.
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
