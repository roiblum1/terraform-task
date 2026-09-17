# Terraform Cheatsheet

## Offline setup (this repo, every new shell)

```bash
cd sigit-targil
source scripts/offline-env.sh   # points terraform init at providers/, no registry needed
```

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

`scripts/offline-env.sh` writes this to `.providers.tfrc` and points
`TF_CLI_CONFIG_FILE` at it:

```hcl
provider_installation {
  filesystem_mirror {
    path    = "<repo>/providers"
    include = ["*/*"]
  }
  direct {
    exclude = ["*/*"]
  }
}
```

`direct { exclude = ["*/*"] }` is what actually blocks registry access —
without it, Terraform would fall back to the network for anything the
mirror doesn't have.
