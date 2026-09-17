# ==============================================================================
# Part B — declare a variable for every hardcoded value from Part A.
#
# main.tf already references var.vsphere_user, var.vsphere_password, etc. —
# declare each one below with the right `type` (and `default` where it makes
# sense). Pay special attention to vsphere_password: see the TODO on it.
# ==============================================================================

# TODO: variable "vsphere_server" — string, your vCenter server hostname.

# TODO: variable "vsphere_user" — string, your vCenter username.

# TODO: variable "vsphere_password" — string.
#   This one needs extra care:
#     - mark it `sensitive = true` (redacts it from plan/apply/console output)
#     - do NOT give it a `default` — a default would sit in this file, in git
#     - at apply time, supply it via:  export TF_VAR_vsphere_password='...'
#   sensitive = true does NOT encrypt the state file — terraform.tfstate
#   still holds the plaintext value, so treat the state file as a secret too.

# TODO: variable "vsphere_datacenter" — string, your datacenter name.

# TODO: variable "vsphere_cluster" — string, your compute cluster name.

# TODO: variable "vm_template" — string, template to clone.

# TODO: variable "network_id" — string. EPG MoRef given by your instructor
#   (e.g. "dvportgroup-1001") — you don't have DVS read access to look it up.

# TODO: variable "datastore_id" — string. Datastore MoRef given by your
#   instructor (e.g. "datastore-2001") — you don't have SDRS access.

# TODO: variable "vm_folder" — string, VM folder path (pre-created for you).

# TODO: variable "student_id" — string, your two-digit student ID.

# TODO: variable "vm_num_cpus" — number, default 2.

# TODO: variable "vm_memory" — number, MB, default 4096.

# TODO: variable "vm_disk_size" — number, GB, default 40.
