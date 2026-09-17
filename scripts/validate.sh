#!/usr/bin/env bash
# Repo-wide sanity check, meant to be run from the repo root:
#
#   ./scripts/validate.sh
#
# - terraform fmt -check across the whole repo (exercise skeletons included —
#   their TODO blanks are still valid HCL, so they must stay well-formatted).
# - terraform init (offline, via the local provider mirror) + terraform
#   validate for every solutions/part-* directory. These are expected to be
#   complete and pass validate cleanly.
# - exercise/part-* directories are intentionally left unfinished (that's
#   the assignment) and are NOT validated here — only fmt-checked above.
set -euo pipefail

repo_root="$(cd "$(dirname "${0}")/.." && pwd)"
cd "${repo_root}"

echo "==> terraform fmt -check -recursive"
if ! terraform fmt -check -recursive -diff .; then
  echo "FAILED: some files are not terraform fmt-clean (see diff above)." >&2
  exit 1
fi
echo "OK"
echo

if [[ ! -d "${repo_root}/providers" ]]; then
  echo "ERROR: providers/ mirror not found at ${repo_root}/providers" >&2
  exit 1
fi

tfrc_path="${repo_root}/.providers.tfrc"
cat > "${tfrc_path}" <<EOF
provider_installation {
  filesystem_mirror {
    path    = "${repo_root}/providers"
    include = ["*/*"]
  }
  direct {
    exclude = ["*/*"]
  }
}
EOF
export TF_CLI_CONFIG_FILE="${tfrc_path}"

status=0
for dir in "${repo_root}"/solutions/*/; do
  name="$(basename "${dir}")"
  echo "==> solutions/${name}: terraform init"
  if ! (cd "${dir}" && terraform init -input=false); then
    echo "FAILED: init in solutions/${name}" >&2
    status=1
    continue
  fi
  echo "==> solutions/${name}: terraform validate"
  if ! (cd "${dir}" && terraform validate); then
    echo "FAILED: validate in solutions/${name}" >&2
    status=1
  fi
  echo
done

rm -f "${tfrc_path}"

if [[ "${status}" -eq 0 ]]; then
  echo "All checks passed."
else
  echo "One or more checks FAILED — see above." >&2
fi
exit "${status}"
