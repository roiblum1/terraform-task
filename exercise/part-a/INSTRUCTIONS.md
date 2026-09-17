# Part A — Your First VM

## Goal

Clone a single VM from a template in vSphere, connect it to the right
network, and get `terraform apply` to succeed. Nothing here is elegant yet —
everything is hardcoded, including the vCenter password. That's deliberate;
Part B is where we clean it up.

## Files

- `versions.tf` — complete, don't touch it. Pins the `vmware/vsphere`
  provider.
- `main.tf` — has `# TODO` blanks for you to fill in.

## What you need from your instructor

- vCenter server / your username & password
- Datacenter name, compute cluster name, template name
- **EPG (network) MoRef** and **datastore MoRef** — you don't have
  permission to look these up by name yourself (see README.md
  "Why some values are pre-given" if you want to know why)
- A VM folder path to place your VM in
- Your two-digit student ID

## Steps

1. `cd exercise/part-a`
2. Fill in every `# TODO` in `main.tf`.
3. `terraform init` — works offline, no setup needed; the providers come
   from this repo.
4. `terraform plan` — read it. Does it show exactly one VM being created?
5. `terraform apply`
6. Confirm the VM exists in vCenter, named `student-<id>-tf-vm-01`.
7. When you're done, `terraform destroy` to clean up before moving on.

## Hints

- `data.vsphere_virtual_machine.template` exposes `.guest_id`, `.id`
  (this is the UUID `clone.template_uuid` wants), and `.disks[0]`
  (`.disks[0].thin_provisioned` tells you whether the template's disk is
  thin-provisioned — your VM's disk must match).
- `local.network_id` / `local.datastore_id` are already declared for you in
  the `locals` block — just fill in the values and reference them.
- If `terraform init` tries to reach the internet and fails, check that
  `terraform.d/plugins` still exists in this directory and points at the
  repo's `providers/` folder — that symlink is what makes init work offline.

## Acceptance criteria

- `terraform validate` passes with no errors.
- `terraform apply` creates exactly one `vsphere_virtual_machine`.
- The VM is named `student-<your-id>-tf-vm-01` and is reachable in vCenter
  under the given folder, on the given network.
