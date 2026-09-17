# Terraform on vSphere — Student Exercise

A four-part, hands-on Terraform exercise built for a **fully disconnected**
vSphere lab: no internet access, no registry access, no read permission on
the DVS or on datastore clusters (SDRS). Students provision VMs from a
template, scale them, and end up with a live Ansible inventory generated
straight from what vSphere reports back.

## What gets built, part by part

| Part | What's new | Concept |
|------|-----------|---------|
| A | One hardcoded VM | `provider`, `data`, `resource`, `clone` |
| B | `variables.tf`, secret handling | `variable`, `sensitive`, `TF_VAR_*` |
| B2 | VM moved into `modules/vm/` | module inputs/outputs |
| C | 3 auto-indexed VMs | `count`, `format()` |
| D | IPs → Ansible inventory | outputs, `for` expressions, `templatefile()` |

Each part lives in its own directory under `exercise/` as a self-contained
root module, so getting stuck on one part doesn't block starting the next.
Full working answers are in the matching `solutions/<part>/` directory.

```
sigit-targil/
├── providers/          # offline provider mirror (committed — see below)
├── scripts/
│   ├── offline-env.sh  # source this before any `terraform init`
│   └── validate.sh     # fmt + init + validate everything in solutions/
├── exercise/
│   ├── part-a/ … part-d/
├── solutions/
│   ├── part-a/ … part-d/
└── CHEATSHEET.md
```

## Why some values are pre-given instead of looked up

Students have read access to the datacenter, compute cluster, and
templates, so those are looked up by name with `data` sources as usual.

Two things are **not** looked up by name and are instead handed to students
as raw vSphere managed object IDs (MoRefs):

- **The network (EPG)** — looking it up by name requires
  `data.vsphere_distributed_virtual_switch`, which needs DVS read
  permission students don't have. Instead they get the port group's MoRef
  directly, e.g. `dvportgroup-1001`, and pass it straight to
  `network_interface.network_id`.
- **The datastore** — students don't have access to the datastore cluster
  (SDRS), so instead of `data.vsphere_datastore_cluster` they get one
  specific datastore's MoRef, e.g. `datastore-2001`, passed straight to
  `datastore_id`.

Everything else (datacenter, compute cluster, template) is looked up by
name via `data.vsphere_*`, which is the normal/expected pattern and worth
seeing at least once.

## Offline provider setup

There is no registry access in this network, so the `vmware/vsphere` and
`hashicorp/local` provider binaries are committed directly under
`providers/` as a Terraform filesystem mirror (`linux_amd64` and
`darwin_arm64`, built with `terraform providers mirror`).

Before running `terraform init` **anywhere** in this repo:

```bash
cd sigit-targil
source scripts/offline-env.sh
```

This writes a temporary `.providers.tfrc` (gitignored — it has an absolute
path, so it can't be committed) and exports `TF_CLI_CONFIG_FILE` to point
at it. From there, `terraform init` in any `exercise/part-*` or
`solutions/part-*` directory installs providers from the local mirror with
zero network calls. Run this once per shell session.

If you ever need to rebuild or extend the mirror (e.g. add a platform or
provider):

```bash
terraform providers mirror -platform=linux_amd64 -platform=darwin_arm64 providers
```

## Running a part

```bash
source scripts/offline-env.sh        # once per shell
cd exercise/part-a                   # or solutions/part-a to see the answer
# fill in the TODOs per that part's INSTRUCTIONS.md
terraform init
terraform plan
terraform apply
# ...
terraform destroy                    # clean up before moving to the next part
```

Each part's `INSTRUCTIONS.md` has the goal, the specific blanks to fill,
hints, and acceptance criteria.

---

## Instructor notes

### What to pre-create per student / cohort

- A VM template with **open-vm-tools installed** (Part D needs VMware Tools
  to report the guest IP back to Terraform).
- **DHCP enabled** on the student EPG (Part D relies on this — without it,
  `default_ip_address` stays empty and the wait times out).
- A vCenter account per student with permission to: read the datacenter,
  compute cluster, and template by name; create/clone/destroy VMs in their
  assigned folder; **no** DVS or datastore-cluster read permission required.
- A VM folder per student (Terraform doesn't create it — creating folders
  needs datacenter-level permission students don't have).

### Getting the EPG and datastore MoRefs to hand out

From the vCenter MOB, or with PowerCLI:

```powershell
(Get-VDPortgroup -Name '<epg-name>').ExtensionData.MoRef.Value   # -> dvportgroup-NNNN
(Get-Datastore -Name '<datastore-name>').ExtensionData.MoRef.Value  # -> datastore-NNNN
```

Give each student their `dvportgroup-NNNN` / `datastore-NNNN` pair along
with their vCenter credentials, datacenter, cluster, and template names —
that's everything `terraform.tfvars.example` in each part asks for.

### Cleanup between cohorts / runs

Each `apply` creates real VMs. Remind students to `terraform destroy` at
the end of each part before moving to the next — otherwise Part C's 3 VMs
will pile up alongside a still-running Part A/B VM with a name collision
risk if `student_id` is reused.

### Verifying the repo itself

`./scripts/validate.sh` runs `terraform fmt -check` across the whole repo
and `init` + `validate` (offline, via the mirror) against every
`solutions/part-*` directory. It does not touch `exercise/part-*` beyond
fmt-checking — those are expected to fail `validate` until a student fills
in the blanks.
