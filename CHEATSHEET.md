# Terraform Cheatsheet

## Offline setup

None. Just `cd` into a part directory and run `terraform init` — the
providers come from the repo's local mirror automatically. See the bottom
of this file if you want to know how that works.

## Core workflow

```bash
terraform init        # download/link providers + modules. Re-run after
                       # adding/changing a module or a required_providers block.
terraform fmt          # auto-format *.tf files in the current directory
terraform fmt -recursive
terraform validate     # check syntax + internal consistency (no vCenter calls)
terraform plan          # show what would change, without changing anything
terraform apply         # apply the plan (prompts for confirmation)
terraform apply -auto-approve   # skip the confirmation prompt
terraform destroy       # tear down everything this state file knows about
```

## Inspecting state and outputs

```bash
terraform output                  # show all outputs
terraform output vm_name          # show one output
terraform state list              # list every resource Terraform is tracking
terraform state show <address>    # show one resource's current attributes
                                   # e.g. terraform state show 'module.vm[0].vsphere_virtual_machine.vm'
```

## Variables

Four ways to set `var.foo`, in increasing priority (later wins):

1. `default = ...` in the `variable` block
2. `terraform.tfvars` (or `*.auto.tfvars`) in the working directory
3. `TF_VAR_foo=...` environment variable
4. `-var 'foo=...'` on the command line

**Always use #3 for secrets** (like `vsphere_password`) — never a default,
never a `.tfvars` file:

```bash
export TF_VAR_vsphere_password='...'
terraform plan
```

Marking a variable `sensitive = true` hides it from `plan`/`apply`/`console`
output. It does **not** encrypt the state file — `terraform.tfstate` still
holds the plaintext value, so the state file must be treated as a secret
too (gitignored here, same as `*.tfvars`).

## Useful flags

```bash
terraform plan -out=tfplan        # save the plan, then...
terraform apply tfplan            # ...apply exactly that plan (no surprises)
terraform apply -target=<address> # only touch one resource (debugging only)
terraform validate -json          # machine-readable validate output
```

## HCL bits used in this exercise

- **`count`** — `count = 3` on a resource/module turns it into a list:
  `module.vm[0]`, `module.vm[1]`, `module.vm[2]`. `count.index` is 0-based
  inside the block.
- **`format("%02d", n)`** — zero-pads a number: `format("%02d", 1)` → `"01"`.
- **`for` expression** — `[for x in list : x.name]` builds a new list (or
  `{for x in list : x.key => x.value}` for a map) from an existing one.
- **`templatefile(path, vars)`** — renders a file as a template, with
  `%{ for x in list ~} ... %{ endfor ~}` directives and `${x}`
  interpolations inside the template file itself.

## Offline provider mirror internals

Terraform automatically searches a few "implied local mirror" directories
before it ever contacts the registry. One of them is `terraform.d/plugins`
inside the directory you run Terraform from.

So every part directory here contains:

```
terraform.d/plugins -> ../../../providers
```

which points at the one real copy of the mirror at the repo root. That's
the whole mechanism — no CLI config file, no `TF_CLI_CONFIG_FILE`, no
setup script, and the binaries are stored once rather than once per part.

The mirror is in Terraform's "packed" layout, the same thing
`terraform providers mirror` produces:

```
providers/registry.terraform.io/vmware/vsphere/
├── index.json                                        # which versions exist
├── 2.15.0.json                                       # per-platform checksums
├── terraform-provider-vsphere_2.15.0_linux_amd64.zip
└── terraform-provider-vsphere_2.15.0_darwin_arm64.zip
```

Each part's committed `.terraform.lock.hcl` pins the version and the
checksums for both platforms, so `init` verifies what it pulls from the
mirror and never needs the network to resolve anything.

If a provider were ever missing from the mirror, Terraform would silently
fall back to the registry — which fails in this network. That's why
`scripts/validate.sh` runs its checks behind a dead proxy: it turns that
silent fallback into a loud failure.
