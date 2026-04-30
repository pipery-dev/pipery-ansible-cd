#!/usr/bin/env bash
set -euo pipefail

# Pipery Ansible CD - Main orchestrator
# Orchestrates: read config → setup environment → deploy via Ansible → status check

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
LOG="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "[pipery-ansible-cd] ERROR: project path does not exist: $PROJECT_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$LOG")"

# Step: read config
"$SCRIPT_DIR/read-config.sh"

# Step: setup (install dependencies, prepare environment)
if [ "${INPUT_SKIP_SETUP:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-setup.sh"
else
  echo "[pipery-ansible-cd] Skipping setup step."
fi

# Step: deploy
if [ "${INPUT_SKIP_DEPLOY:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-deploy.sh"
else
  echo "[pipery-ansible-cd] Skipping deploy step."
fi

# Step: status check
if [ "${INPUT_SKIP_STATUS_CHECK:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-status.sh"
else
  echo "[pipery-ansible-cd] Skipping status check step."
fi

# Final success log entry (always written)
printf '{"event":"deploy","status":"success","target":"ansible","mode":"cd"}\n' >> "${INPUT_LOG_FILE:-pipery.jsonl}"

echo "[pipery-ansible-cd] CD pipeline completed for: ${PROJECT_PATH}"
