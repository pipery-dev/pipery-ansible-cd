#!/usr/bin/env psh
# Pipery Ansible CD — setup step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Setup"
echo "project_path=$INPUT_PROJECT_PATH"
echo "::endgroup::"
