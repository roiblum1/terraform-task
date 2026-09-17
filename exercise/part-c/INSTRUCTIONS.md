# Part C — Scale to Three VMs

## Goal

Turn your single-VM module call into three, auto-named
`student-<id>-tf-vm-01`, `-02`, `-03`, using `count`.

## Files

- `modules/vm/` — complete, unchanged from Part B2. You are not touching
  the module itself in this part, only how the root calls it.
- `variables.tf` — one `# TODO`: add `vm_count`.
- `main.tf` — the `module "vm"` block has two `# TODO` lines: `count` and
  the `name` expression.
- `outputs.tf` — one `# TODO`.

## Steps

1. `cd exercise/part-c`
2. Add `variable "vm_count"` to `variables.tf` (number, default `3`).
3. In `main.tf`, add `count = var.vm_count` to the `module "vm"` block.
4. Add the `name` line using `format("%02d", count.index + 1)` to zero-pad
   the index (see the comment above it for exactly what it should look
   like).
5. Fix `outputs.tf` — with `count` in play, `module.vm` is now a **list**
   of module instances, not a single one, so `module.vm.name` no longer
   works. Use a `for` expression instead.
6. `terraform init && terraform plan` — you should see 3 VMs to add, named
   `student-<id>-tf-vm-01/02/03`.
7. `terraform apply`, then `terraform destroy` when done.

## Try it

Change `vm_count` to `5` and re-plan. Then change it back to `2` and
re-plan — notice what happens to the VM that used to be `-03`: with
`count`, Terraform indexes by position, so shrinking the count destroys
VMs from the end. (`for_each` avoids this, at the cost of needing a map
keyed by name instead of a plain number — worth knowing about, not
required here.)

## Acceptance criteria

- `terraform validate` passes.
- `terraform apply` creates exactly `var.vm_count` VMs.
- VM names are `student-<id>-tf-vm-01`, `-02`, `-03` (zero-padded, no gaps).
- `terraform output vm_names` prints all of them.
