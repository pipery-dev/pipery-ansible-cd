#!/usr/bin/env bash
# Pipery Ansible CD — deploy step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Deploy"
project_path="${INPUT_PROJECT_PATH:-.}"
playbook="${INPUT_PLAYBOOK:-playbook.yml}"
inventory="${INPUT_INVENTORY:-inventory}"
log="${INPUT_LOG_FILE:-pipery.jsonl}"

cd "$project_path"
if [ ! -f "$playbook" ]; then
  echo "Ansible playbook not found: $playbook; skipping."
  printf '{"event":"ansible_deploy","status":"skipped","reason":"missing_playbook"}\n' >> "$log"
  echo "::endgroup::"
  exit 0
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook is not installed; cannot run $playbook." >&2
  exit 1
fi

args=("$playbook")
if [ -n "$inventory" ]; then
  args+=(-i "$inventory")
fi
if [ "${INPUT_BECOME:-false}" = "true" ]; then
  args+=(--become)
fi
if [ -n "${INPUT_TAGS:-}" ]; then
  args+=(--tags "$INPUT_TAGS")
fi
if [ -n "${INPUT_EXTRA_VARS:-}" ]; then
  args+=(--extra-vars "$INPUT_EXTRA_VARS")
fi

ansible-playbook "${args[@]}"
printf '{"event":"ansible_deploy","status":"success","playbook":"%s"}\n' "$playbook" >> "$log"
echo "::endgroup::"
