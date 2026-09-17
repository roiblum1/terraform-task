# Part B — Variables, and the Password as a Secret

## Goal

Replace every hardcoded value from Part A with a variable, declared in
`variables.tf`. `main.tf` is already wired to `var.*` references — your job
is only `variables.tf`. The important one is `vsphere_password`: it must
never end up in a file that gets committed.

## Files

- `main.tf` — complete, don't touch it. Shows you exactly which variables to
  declare (search for `var.`).
- `variables.tf` — one `# TODO` per variable. Write the `variable` block for
  each.
- `terraform.tfvars.example` — reference for every variable *except* the
  password (on purpose — see below). Copy it to `terraform.tfvars` and edit.
- `outputs.tf` — complete.

## Steps

1. `cd exercise/part-b`
2. `source ../../scripts/offline-env.sh` (from the repo root, or adjust the
   path) if you haven't already this shell session.
3. Write each `variable` block in `variables.tf`.
4. `cp terraform.tfvars.example terraform.tfvars` and fill in your values.
5. `export TF_VAR_vsphere_password='...'` — **not** in terraform.tfvars.
6. `terraform init && terraform plan`
7. `terraform apply`
8. `terraform destroy` when done.

## Why the password needs special treatment

- `sensitive = true` hides the value in `plan`/`apply`/`console` output. It
  does **not** encrypt `terraform.tfstate` — the plaintext value still lands
  there, so the state file itself is a secret and must never be committed
  either (it's gitignored in this repo, same as `*.tfvars`).
- No `default` on `vsphere_password` — if there were one, it would sit in
  this file, in git, for anyone to read. Supplying it via `TF_VAR_*` is the
  standard way to keep a value out of every file entirely.
- `terraform.tfvars.example` deliberately does not show a password line —
  that's a hint, not an oversight.

## Acceptance criteria

- `terraform validate` passes.
- Nowhere in `variables.tf`, `terraform.tfvars`, or `terraform.tfvars.example`
  is there a plaintext password.
- `vsphere_password` is `sensitive = true` with no `default`.
- `terraform plan` output never prints your password.
- `terraform apply` still creates the same VM as Part A.
