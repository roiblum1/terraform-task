# Part D — Gather IPs into an Ansible Inventory

## Goal

After `apply`, produce `inventory.ini` listing every VM's name and the IP
address vSphere reports back for it — ready to hand to `ansible-playbook -i`.

## Why this works

The EPG has DHCP, so the IP isn't known until the VM boots and VMware Tools
phones it home. `modules/vm/main.tf` already sets
`wait_for_guest_net_timeout = 5` for exactly this reason — Terraform waits
(up to 5 minutes) for that to happen before considering the VM "created",
so by the time `apply` finishes, `module.vm[*].ip_address` is populated,
not empty.

## Files

- `modules/vm/`, `main.tf`, `variables.tf` (except `ansible_user`),
  `versions.tf` — complete. `versions.tf` now also requires
  `hashicorp/local` — that's the provider behind `local_file`.
- `variables.tf` — one `# TODO`: `ansible_user`.
- `inventory.tf` — one `# TODO`: the `local_file` resource.
- `templates/inventory.tmpl` — one `# TODO`: the `%{ for }` loop.
- `outputs.tf` — two `# TODO`s.

## Steps

1. `cd exercise/part-d`
2. Add `variable "ansible_user"` to `variables.tf`.
3. Fill in the `local_file` resource in `inventory.tf` — `filename` and
   `content` are both blanked out (see the comments in the file for what
   each needs).
4. Fill in the `%{ for }` loop in `templates/inventory.tmpl`.
5. Add the two outputs in `outputs.tf`.
6. `terraform init` — new provider (`hashicorp/local`), so init is required
   again.
7. `terraform plan` — `local_file.ansible_inventory` should show up
   alongside the 3 VMs.
8. `terraform apply`. This one takes longer than previous parts: it's
   waiting on VMware Tools to report IPs.
9. `cat inventory.ini` — you should see 3 hosts with real IPs.
10. `terraform destroy` when done.

## Hints

- `module.vm` is a list (because of `count` from Part C) — you'll need a
  `for` expression to turn it into the `name`/`ip_address` pairs the
  template wants. See `CHEATSHEET.md` for the syntax.
- `templatefile(path, vars_map)` renders a file as a template — the keys of
  `vars_map` become variables available inside the template.
- If `ip_address` comes back empty in `inventory.ini`, check that the VM
  template has `open-vm-tools` installed and that the EPG actually hands
  out DHCP leases — ask your instructor if unsure.

## Acceptance criteria

- `terraform validate` passes.
- `terraform apply` produces `inventory.ini` with one `ansible_host=<ip>`
  line per VM under `[student_vms]`, and `ansible_user` under
  `[student_vms:vars]`.
- No IP address in the file is empty.
- `terraform output vm_ips` matches what's in the file.
