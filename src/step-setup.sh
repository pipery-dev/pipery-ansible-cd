#!/usr/bin/env bash
# Pipery Ansible CD — setup step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Setup"
project_path="${INPUT_PROJECT_PATH:-.}"
log="${INPUT_LOG_FILE:-pipery.jsonl}"

cd "$project_path"
if [ -n "${INPUT_REQUIREMENTS:-}" ] && [ -f "$INPUT_REQUIREMENTS" ]; then
  python3 -m pip install -r "$INPUT_REQUIREMENTS"
fi
if [ -n "${INPUT_ANSIBLE_REQUIREMENTS:-}" ] && [ -f "$INPUT_ANSIBLE_REQUIREMENTS" ]; then
  if ! command -v ansible-galaxy >/dev/null 2>&1; then
    echo "ansible-galaxy is not installed; cannot install $INPUT_ANSIBLE_REQUIREMENTS." >&2
    exit 1
  fi
  ansible-galaxy install -r "$INPUT_ANSIBLE_REQUIREMENTS"
fi

if [ -n "${INPUT_SSH_KEY:-}" ]; then
  mkdir -p "$HOME/.ssh"
  key_file="$HOME/.ssh/pipery_ansible_key"
  printf '%s\n' "$INPUT_SSH_KEY" > "$key_file"
  chmod 600 "$key_file"
  export ANSIBLE_PRIVATE_KEY_FILE="$key_file"
fi
if [ -n "${INPUT_SSH_KNOWN_HOSTS:-}" ]; then
  mkdir -p "$HOME/.ssh"
  printf '%s\n' "$INPUT_SSH_KNOWN_HOSTS" >> "$HOME/.ssh/known_hosts"
fi

printf '{"event":"ansible_setup","status":"success"}\n' >> "$log"
echo "::endgroup::"
