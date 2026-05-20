#!/usr/bin/env bash
# Pipery Ansible CD — status step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Status"
log="${INPUT_LOG_FILE:-pipery.jsonl}"
printf '{"event":"ansible_status","status":"success"}\n' >> "$log"
echo "::endgroup::"
