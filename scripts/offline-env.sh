#!/usr/bin/env bash
# Source this file (do NOT execute it) from the ROOT of this repo, before
# running any `terraform init` in an exercise/ or solutions/ directory:
#
#   cd sigit-targil
#   source scripts/offline-env.sh
#
# It points Terraform at the provider mirror committed in providers/ instead
# of the public registry, which is unreachable from the disconnected
# network. This mirrors the filesystem_mirror + TF_CLI_CONFIG_FILE pattern
# used by the bootstrap-installer project's ocp_bootstrap/terraform.py.
#
# Works under both bash and zsh. It deliberately does NOT try to locate
# itself via $BASH_SOURCE/$0 (those resolve differently, and unreliably,
# across bash vs zsh when a script is sourced) — instead it requires you to
# be in the repo root, which it verifies by checking for providers/ here.
# (If you run it instead of sourcing it, the exports below won't reach your
# shell and the following `terraform init` will just fail obviously.)

_repo_root="$(pwd)"
_providers_dir="${_repo_root}/providers"

if [[ ! -d "${_providers_dir}" ]]; then
  echo "ERROR: providers/ not found under $(pwd)." >&2
  echo "cd to the repo root (sigit-targil/) first, then re-run:" >&2
  echo "  source scripts/offline-env.sh" >&2
  return 1 2>/dev/null || exit 1
fi

_tfrc_path="${_repo_root}/.providers.tfrc"

cat > "${_tfrc_path}" <<EOF
provider_installation {
  filesystem_mirror {
    path    = "${_providers_dir}"
    include = ["*/*"]
  }
  direct {
    exclude = ["*/*"]
  }
}
EOF

export TF_CLI_CONFIG_FILE="${_tfrc_path}"

echo "Offline mode enabled."
echo "  TF_CLI_CONFIG_FILE = ${TF_CLI_CONFIG_FILE}"
echo "  provider mirror    = ${_providers_dir}"
echo ""
echo "You can now run 'terraform init' in any exercise/solution directory;"
echo "it will install providers from the local mirror with no registry access."

unset _repo_root _providers_dir _tfrc_path
