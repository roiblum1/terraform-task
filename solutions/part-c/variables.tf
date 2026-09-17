# ==============================================================================
# Part C — same as Part B2, plus vm_count so we can scale from one VM to
# several with a single number.
# ==============================================================================

variable "vsphere_server" {
  type        = string
  description = "vCenter server hostname or IP."
}

variable "vsphere_user" {
  type        = string
  description = "vCenter username."
}

variable "vsphere_password" {
  type        = string
  description = <<-EOT
    vCenter password. SENSITIVE — do not put a real value in terraform.tfvars
    or anywhere else that gets committed to git. Supply it at apply time via
    an environment variable instead:

      export TF_VAR_vsphere_password='...'
      terraform plan

    marking a variable sensitive = true only redacts it from CLI output
    (plan/apply/console); it is still stored in plaintext in the state file,
    so the state file itself must be treated as a secret too (see README).
  EOT
  sensitive   = true
  # Deliberately no default — Terraform will refuse to run non-interactively
  # until the value is supplied some other way, which is the point.
}

variable "vsphere_datacenter" {
  type        = string
  description = "Name of the vSphere datacenter."
}

variable "vsphere_cluster" {
  type        = string
  description = "Name of the vSphere compute cluster."
}

variable "vm_template" {
  type        = string
  description = "Name of the VM template to clone."
}

variable "network_id" {
  type        = string
  description = <<-EOT
    Pre-resolved managed object ID (MoRef) of the EPG / distributed port
    group to attach the VMs to, e.g. "dvportgroup-1001". Given by the
    instructor — you don't have read access to the DVS to look this up by
    name yourself.
  EOT
}

variable "datastore_id" {
  type        = string
  description = <<-EOT
    Pre-resolved managed object ID (MoRef) of the datastore to place the VMs
    on, e.g. "datastore-2001". Given by the instructor — you don't have
    access to the datastore cluster (SDRS) to look this up by name.
  EOT
}

variable "vm_folder" {
  type        = string
  description = "vSphere VM folder path to place the VMs in (pre-created by the instructor)."
}

variable "student_id" {
  type        = string
  description = "Your two-digit student ID, e.g. \"01\". Used to name your VMs."
}

variable "vm_count" {
  type        = number
  description = "How many VMs to create. Names auto-index as student-<id>-tf-vm-01, -02, ..."
  default     = 3
}

variable "vm_num_cpus" {
  type        = number
  description = "Number of vCPUs per VM."
  default     = 2
}

variable "vm_memory" {
  type        = number
  description = "Memory per VM, in MB."
  default     = 4096
}

variable "vm_disk_size" {
  type        = number
  description = "Primary disk size per VM, in GB."
  default     = 40
}
