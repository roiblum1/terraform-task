#!/usr/bin/env bash
# Repo-wide sanity check, meant to be run from anywhere:
#
#   ./scripts/validate.sh
#
# - terraform fmt -check across the whole repo (exercise skeletons included —
#   their TODO blanks are still valid HCL, so they must stay well-formatted).
# - Verifies every part directory has its terraform.d/plugins symlink into
#   the shared providers/ mirror (this is what makes `terraform init` work
#   with no network and no setup).
# - terraform init + terraform validate for every solutions/part-* directory,
#   run with a dead proxy so a provider that ISN'T coming from the local
#   mirror fails loudly instead of silently reaching the registry.
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

status=0

echo "==> checking terraform.d/plugins symlinks"
for dir in "${repo_root}"/exercise/*/ "${repo_root}"/solutions/*/; do
  link="${dir}terraform.d/plugins"
  if [[ ! -L "${link}" ]]; then
    echo "FAILED: missing symlink ${link#"${repo_root}/"}" >&2
    status=1
  elif [[ ! -d "${link}/registry.terraform.io" ]]; then
    echo "FAILED: broken symlink ${link#"${repo_root}/"} -> $(readlink "${link}")" >&2
    status=1
  fi
done
[[ "${status}" -eq 0 ]] && echo "OK"
echo

# Dead proxy: proves providers really come from the local mirror. If any
# provider were missing from providers/, init would try the registry and
# fail here instead of quietly succeeding on a connected machine.
export HTTPS_PROXY="http://127.0.0.1:1"
export HTTP_PROXY="http://127.0.0.1:1"
unset TF_CLI_CONFIG_FILE

for dir in "${repo_root}"/solutions/*/; do
  name="$(basename "${dir}")"
  echo "==> solutions/${name}: terraform init (offline)"
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

if [[ "${status}" -eq 0 ]]; then
  echo "All checks passed."
else
  echo "One or more checks FAILED — see above." >&2
fi
exit "${status}"
