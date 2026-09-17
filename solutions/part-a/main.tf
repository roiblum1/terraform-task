# ==============================================================================
# Part A — one VM, everything hardcoded.
#
# This is deliberately "wrong": real values are typed straight into the
# resource, including the vSphere password in plaintext. Part B is where we
# fix that. The point of Part A is only to get one VM cloned from a template
# and connected to the right network, end to end.
# ==============================================================================

provider "vsphere" {
  user                 = "student01@vsphere.local"
  password             = "CHANGE-ME" # plaintext on purpose — see Part B
  vsphere_server       = "vcenter.lab.local"
  allow_unverified_ssl = true
}

# --- Objects looked up by name --------------------------------------------
# Students DO have read access to these, so a name lookup works fine.

data "vsphere_datacenter" "dc" {
  name = "DC1"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "Compute-Cluster-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "rhel9-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# --- Objects handed to us as pre-resolved IDs -------------------------------
# Students do NOT have read access to the DVS or to datastore clusters (SDRS),
# so the EPG (distributed port group) and the datastore are given directly as
# vSphere managed object IDs instead of being looked up by name. Ask your
# instructor for these values, or see README.md "Instructor notes" for how
# they were generated.

locals {
  network_id   = "dvportgroup-1001" # pre-resolved EPG MoRef — given by instructor
  datastore_id = "datastore-2001"   # pre-resolved datastore MoRef — given by instructor
}

# --- The VM -------------------------------------------------------------

resource "vsphere_virtual_machine" "vm" {
  name             = "student-01-tf-vm-01"
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = local.datastore_id
  folder           = "workloads/students/student-01"

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = local.network_id
  }

  disk {
    label            = "disk0"
    size             = 40
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}

output "vm_name" {
  value = vsphere_virtual_machine.vm.name
}
