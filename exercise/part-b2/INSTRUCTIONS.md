# Part B2 — Extract the VM into a Module

## Goal

Move the `vsphere_virtual_machine` resource out of the root module and into
a reusable child module at `modules/vm/`. When you're done, the root module
should contain no `resource "vsphere_virtual_machine"` block at all — only a
`module "vm" { ... }` call.

## Files

- `variables.tf`, `versions.tf`, `terraform.tfvars.example` — complete,
  unchanged from Part B.
- `main.tf` — provider + data sources are complete; the module call is
  commented out as a `# TODO` block for you to uncomment and adapt.
- `outputs.tf` — one `# TODO`.
- `modules/vm/variables.tf`, `modules/vm/versions.tf` — complete. Look here
  first: every input the module needs is already declared.
- `modules/vm/main.tf` — the resource body, with `# TODO` on every argument.
- `modules/vm/outputs.tf` — three `# TODO` outputs.

## Steps

1. `cd exercise/part-b2`
2. In `modules/vm/main.tf`: uncomment each line, replacing the hardcoded
   values from Part A with the matching `var.*` from `modules/vm/variables.tf`.
3. In `modules/vm/outputs.tf`: add the three outputs.
4. In root `main.tf`: uncomment the `module "vm"` block.
5. In root `outputs.tf`: add `vm_name`.
6. `source ../../scripts/offline-env.sh` if needed, then `terraform init` —
   **required again**, even though you ran it in Part B, because Terraform
   needs to discover the new module.
7. `terraform plan` — should show the same single VM as Part B, just created
   through the module now.
8. `terraform apply`, then `terraform destroy` when done.

## Key idea

A module's `resource` block can only see what's declared in **its own**
`variables.tf` — it never reaches out to the root module's variables
directly. And a module's only way to hand information back up is through
`outputs.tf`. That's the entire interface, in both directions.

Notice also: a child module declares `required_providers` (in
`versions.tf`) but never its own `provider "vsphere" { ... }` block — the
provider configuration is inherited from the root module.

## Acceptance criteria

- `terraform validate` passes.
- No `resource "vsphere_virtual_machine"` block exists outside
  `modules/vm/main.tf`.
- `terraform apply` creates the same VM as Part B.
- `terraform output vm_name` prints the VM's name.
