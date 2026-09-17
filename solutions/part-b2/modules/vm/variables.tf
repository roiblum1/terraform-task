variable "name" {
  type        = string
  description = "Name of the VM."
}

variable "resource_pool_id" {
  type        = string
  description = "ID of the resource pool to place the VM in."
}

variable "datastore_id" {
  type        = string
  description = "Managed object ID of the datastore to place the VM on."
}

variable "folder" {
  type        = string
  description = "vSphere VM folder path."
}

variable "guest_id" {
  type        = string
  description = "Guest OS identifier, taken from the template."
}

variable "template_uuid" {
  type        = string
  description = "UUID of the template to clone from."
}

variable "disk_thin_provisioned" {
  type        = bool
  description = "Whether the template's disk is thin-provisioned (must match on clone)."
}

variable "network_id" {
  type        = string
  description = "Managed object ID of the network (EPG / port group) to attach."
}

variable "num_cpus" {
  type        = number
  description = "Number of vCPUs."
}

variable "memory" {
  type        = number
  description = "Memory in MB."
}

variable "disk_size" {
  type        = number
  description = "Primary disk size in GB."
}
