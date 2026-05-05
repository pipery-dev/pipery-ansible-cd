# Pipery Ansible CD

CD pipeline for Ansible: install requirements → run playbook → verify status. Deploy to VMs or bare metal.

## Status

- Owner: `pipery-dev`
- Repository: `pipery-ansible-cd`
- Marketplace category: `continuous-integration`
- Current version: `3.0.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-ansible-cd@v3
        with:
          project_path: .
          config_file: .pipery/config.yaml
          playbook: playbook.yml
          inventory: inventory
          requirements: 
          ansible_requirements: 
          extra_vars: 
          ssh_key: 
          ssh_known_hosts: 
          become: false
          tags: 
          skip_requirements: false
          skip_deploy: false
          skip_status_check: false
          log_file: pipery.jsonl
```

## GitLab CI

This repository also includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as the reference implementation when you want to run the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps the action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and keeps the same skip controls where the GitHub Action exposes them. Store credentials such as deploy tokens, registry passwords, and cloud provider keys as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-ansible-cd/v3/.gitlab-ci.yml
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree. |
| `config_file` | no | `.pipery/config.yaml` | Path to the pipery config file. |
| `playbook` | no | `playbook.yml` | Path to the Ansible playbook file. |
| `inventory` | no | `inventory` | Path to the Ansible inventory file. |
| `requirements` | no | `` | Path to requirements.txt for pip. |
| `ansible_requirements` | no | `` | Path to requirements.yml for ansible-galaxy. |
| `extra_vars` | no | `` | Extra variables as JSON or key=val pairs. |
| `ssh_key` | no | `` | SSH private key for connecting to hosts. |
| `ssh_known_hosts` | no | `` | Known hosts content for SSH. |
| `become` | no | `false` | Use sudo/become for privilege escalation. |
| `tags` | no | `` | Comma-separated playbook tags to run. |
| `skip_requirements` | no | `false` | Skip pip/galaxy requirements install. |
| `skip_deploy` | no | `false` | Skip playbook run step. |
| `skip_status_check` | no | `false` | Skip status check step. |
| `log_file` | no | `pipery.jsonl` | Path to write the JSONL log file. |

## Outputs

No outputs.

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
