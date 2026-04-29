# Pipery Ansible CD

Reusable GitHub Action for Ansible CD with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Ansible%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-ansible-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CD
on:
  push:
    branches: [main]

jobs:
  cd:
    uses: pipery-dev/pipery-ansible-cd@v1
    with:
      project_path: .
    secrets: inherit
```

## Pipeline steps

install pip requirements → run playbook → status check

Every step is logged to `pipery.jsonl` via psh and uploaded as a GitHub Actions artifact.

## Inputs

| Input | Description | Default |
|---|---|---|
| `project_path` | Path to the project source tree. | `.` |
| `config_file` | Path to the pipery config file. | `.github/pipery/config.yaml` |
| `playbook` | Path to the Ansible playbook file. | `playbook.yml` |
| `inventory` | Path to the Ansible inventory file. | `inventory` |
| `requirements` | Path to requirements.txt for pip. | `` |
| `ansible_requirements` | Path to requirements.yml for ansible-galaxy. | `` |
| `extra_vars` | Extra variables as JSON or key=val pairs. | `` |
| `ssh_key` | SSH private key for connecting to hosts. | `` |
| `ssh_known_hosts` | Known hosts content for SSH. | `` |
| `become` | Use sudo/become for privilege escalation. | `false` |
| `tags` | Comma-separated playbook tags to run. | `` |
| `skip_requirements` | Skip pip/galaxy requirements install. | `false` |
| `skip_deploy` | Skip playbook run step. | `false` |
| `skip_status_check` | Skip status check step. | `false` |
| `log_file` | Path to write the JSONL log file. | `pipery.jsonl` |

## Observability

Each run produces a `pipery.jsonl` file. Upload it as an artifact and inspect it with the [Pipery Dashboard](https://dash.pipery.dev).

## License

MIT — see [LICENSE](LICENSE).
