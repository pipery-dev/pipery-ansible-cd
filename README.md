# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-ansible-cd/main/assets/icon.png" alt="Pipery Ansible CD" width="28" align="center" /> Pipery Ansible CD

Reusable GitHub Action for Ansible-based deployment with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Ansible%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-ansible-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-ansible-cd@v1
        with:
          playbook: deploy.yml
          inventory: inventory/production
          ssh_key: ${{ secrets.SSH_KEY }}
```

## Pipeline Overview

| Step | Description | Skip Input |
| --- | --- | --- |
| Requirements | Install pip and Ansible dependencies | `skip_requirements` |
| Deploy | Execute Ansible playbook | `skip_deploy` |
| Status check | Verify deployment | `skip_status_check` |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `playbook` | `playbook.yml` | Path to the Ansible playbook file. |
| `inventory` | `inventory` | Path to the Ansible inventory file. |
| `requirements` | `` | Path to requirements.txt for pip. |
| `ansible_requirements` | `` | Path to requirements.yml for ansible-galaxy. |
| `extra_vars` | `` | Extra variables as JSON or key=val pairs. |
| `ssh_key` | `` | SSH private key for connecting to hosts. |
| `ssh_known_hosts` | `` | Known hosts content for SSH. |
| `become` | `false` | Use sudo/become for privilege escalation. |
| `tags` | `` | Comma-separated playbook tags to run. |
| `log_file` | `pipery.jsonl` | Path to write the JSONL log file. |
| `skip_requirements` | `false` | Skip pip/galaxy requirements install. |
| `skip_deploy` | `false` | Skip playbook run step. |
| `skip_status_check` | `false` | Skip status check step. |

## Usage Examples

### Example 1: Basic Ansible playbook deployment

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-ansible-cd@v1
        with:
          playbook: deploy.yml
          inventory: inventory/production
          ssh_key: ${{ secrets.SSH_KEY }}
```

### Example 2: With Ansible Galaxy requirements

```yaml
- uses: pipery-dev/pipery-ansible-cd@v1
  with:
    playbook: site.yml
    inventory: inventories/production/hosts.yml
    ansible_requirements: requirements.yml
    ssh_key: ${{ secrets.SSH_KEY }}
```

### Example 3: Run specific tags only

```yaml
- uses: pipery-dev/pipery-ansible-cd@v1
  with:
    playbook: deploy.yml
    inventory: inventory/production
    tags: docker,service
    ssh_key: ${{ secrets.SSH_KEY }}
```

### Example 4: With extra variables and privilege escalation

```yaml
- uses: pipery-dev/pipery-ansible-cd@v1
  with:
    playbook: deploy.yml
    inventory: inventory/production
    extra_vars: '{"version":"1.2.3","env":"prod"}'
    become: true
    ssh_key: ${{ secrets.SSH_KEY }}
```

### Example 5: With Python dependencies

```yaml
- uses: pipery-dev/pipery-ansible-cd@v1
  with:
    playbook: deploy.yml
    inventory: inventory/production
    requirements: requirements.txt
    ansible_requirements: requirements.yml
    ssh_key: ${{ secrets.SSH_KEY }}
```

### Example 6: Known hosts configuration

```yaml
- uses: pipery-dev/pipery-ansible-cd@v1
  with:
    playbook: deploy.yml
    inventory: inventory/production
    ssh_key: ${{ secrets.SSH_KEY }}
    ssh_known_hosts: ${{ secrets.SSH_KNOWN_HOSTS }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-ansible-cd/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `SSH_KEY` - SSH private key (base64-encoded)
- `SSH_KNOWN_HOSTS` - Known hosts content
- `ANSIBLE_PLAYBOOK` - Path to playbook file
- `ANSIBLE_INVENTORY` - Path to inventory file

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `SSH_KEY` - SSH private key (base64-encoded)
   - `SSH_KNOWN_HOSTS` - Known hosts content
   - `ANSIBLE_PLAYBOOK` - Playbook file path
   - `ANSIBLE_INVENTORY` - Inventory file path
3. Commit to trigger deployment

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → requirements → deploy → status_check → logs

### Features

- Support for VMs and bare metal servers
- Ansible Galaxy role/collection support
- Python dependency management
- SSH key-based authentication
- Privilege escalation (become)
- Tag-based playbook execution
- Extra variables support
- Known hosts management
- JSONL-based pipeline logging
- 90-day log retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
