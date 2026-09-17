# ==============================================================================
# Part A — clone ONE VM from a template and connect it to the right network.
#
# Everything here is hardcoded on purpose (no variables yet — that's Part B).
# Fill in every # TODO below. See INSTRUCTIONS.md for the values to use and
# hints for each blank.
# ==============================================================================

provider "vsphere" {
  user                 = "" # TODO: your vCenter username, e.g. "student01@vsphere.local"
  password             = "" # TODO: your vCenter password (yes, plaintext — Part B fixes this)
  vsphere_server       = "" # TODO: vCenter server hostname, e.g. "vcenter.lab.local"
  allow_unverified_ssl = true
}

# --- Objects looked up by name --------------------------------------------
# You DO have read access to these, so a name lookup works fine.

data "vsphere_datacenter" "dc" {
  name = "" # TODO: your datacenter name, e.g. "DC1"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "" # TODO: your compute cluster name, e.g. "Compute-Cluster-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "" # TODO: the template to clone, e.g. "rhel9-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# --- Objects handed to you as pre-resolved IDs -------------------------------
# You do NOT have read access to the DVS or to datastore clusters (SDRS), so
# the EPG (distributed port group) and the datastore are given directly as
# vSphere managed object IDs instead of being looked up by name. Ask your
# instructor for these two values.

locals {
  network_id   = "" # TODO: EPG MoRef given by your instructor, e.g. "dvportgroup-1001"
  datastore_id = "" # TODO: datastore MoRef given by your instructor, e.g. "datastore-2001"
}

# --- The VM -------------------------------------------------------------
# Name it student-<your-id>-tf-vm-01, e.g. "student-01-tf-vm-01".

resource "vsphere_virtual_machine" "vm" {
  name             = "" # TODO: student-<your-id>-tf-vm-01
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id     = local.datastore_id
  folder           = "" # TODO: VM folder path given by your instructor

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = "" # TODO: wire this up to local.network_id
  }

  disk {
    label            = "disk0"
    size             = 40
    thin_provisioned = "" # TODO: match the template's disk — see data.vsphere_virtual_machine.template
  }

  clone {
    template_uuid = "" # TODO: the template's ID (not its name)
  }
}

output "vm_name" {
  value = vsphere_virtual_machine.vm.name
}
