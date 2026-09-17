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
# module you just wrote under ./modules/vm. Wire every argument it needs:
#
# module "vm" {
#   source = "./modules/vm"
#
#   name             = "student-${var.student_id}-tf-vm-01"
#   resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
#   datastore_id     = var.datastore_id
#   folder           = var.vm_folder
#   network_id       = var.network_id
#
#   guest_id              = data.vsphere_virtual_machine.template.guest_id
#   template_uuid         = data.vsphere_virtual_machine.template.id
#   disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
#
#   num_cpus  = var.vm_num_cpus
#   memory    = var.vm_memory
#   disk_size = var.vm_disk_size
# }
