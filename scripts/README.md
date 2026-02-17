# GitHub Repository Ruleset Setup Scripts

This directory contains scripts to create a GitHub repository ruleset for protecting the `main` branch with enterprise-grade settings.

## Overview

The ruleset provides the following protection rules:

1. **Restrict creations** (`creation`) — Only bypass users can create matching refs
2. **Restrict updates** (`update`) — Only bypass users can push directly
3. **Restrict deletions** (`deletion`) — Prevents branch deletion
4. **Require linear history** (`required_linear_history`) — Clean git history, no merge commits
5. **Require signed commits** (`required_signatures`) — Verifies commit authenticity
6. **Require a pull request before merging** (`pull_request`) with:
   - 1 required approving review
   - Dismiss stale reviews on push
   - Required review thread resolution
7. **Block force pushes** (`non_fast_forward`) — Prevents history rewriting

## Files

- **`ruleset-config.json`** - JSON configuration for the GitHub ruleset
- **`setup-ruleset.sh`** - Bash script using GitHub CLI (`gh`)
- **`setup-ruleset.py`** - Python script using GitHub REST API

## Option 1: Using the Bash Script (Recommended)

### Prerequisites

- [GitHub CLI (`gh`)](https://cli.github.com/) must be installed
- Authenticated with GitHub CLI (run `gh auth login`)
- Admin permissions on the `orpaynter/orpaynter-super-nexus` repository

### Usage

```bash
# Make sure you're authenticated
gh auth login

# Run the script
./scripts/setup-ruleset.sh
```

The script will:
1. Verify prerequisites (GitHub CLI installation and authentication)
2. Display the ruleset configuration
3. Ask for confirmation
4. Create the ruleset via the GitHub API
5. Display the created ruleset details

## Option 2: Using the Python Script

### Prerequisites

- Python 3.6 or higher
- `requests` library installed: `pip install requests`
- GitHub personal access token with `repo` and `admin:repo_hook` scopes
- Admin permissions on the `orpaynter/orpaynter-super-nexus` repository

### Create a GitHub Token

1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Select scopes: `repo` (Full control of private repositories)
4. Generate and copy the token

### Usage

```bash
# Set your GitHub token as an environment variable
export GITHUB_TOKEN=your_token_here

# Install dependencies
pip install requests

# Run the script
python3 scripts/setup-ruleset.py
```

Or provide the token via command line:

```bash
python3 scripts/setup-ruleset.py --token your_token_here
```

The script will:
1. Verify prerequisites (Python requests library, GitHub token)
2. Load and display the ruleset configuration
3. Ask for confirmation
4. Create the ruleset via the GitHub REST API
5. Display the created ruleset details

## Option 3: Using cURL Directly

If you prefer to use `curl` directly:

```bash
# Set your GitHub token
export GITHUB_TOKEN=your_token_here

# Create the ruleset
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/orpaynter/orpaynter-super-nexus/rulesets \
  -d @scripts/ruleset-config.json
```

## Customization

To modify the ruleset configuration, edit `ruleset-config.json` before running any of the scripts.

### Key Configuration Options

- **`name`**: Name of the ruleset
- **`enforcement`**: `active` (enforced) or `evaluate` (test mode)
- **`bypass_actors`**: Array of users/teams who can bypass the rules (currently empty for strictest protection)
- **`conditions.ref_name.include`**: Branches to protect (currently `refs/heads/main`)
- **`rules`**: Array of protection rules

## Verification

After running the script, you can verify the ruleset was created:

1. Go to your repository on GitHub
2. Navigate to Settings > Rules > Rulesets
3. You should see "main-branch-protection" listed as Active

Or use the GitHub CLI:

```bash
gh api repos/orpaynter/orpaynter-super-nexus/rulesets
```

## Troubleshooting

### Authentication Errors

- **Bash script**: Run `gh auth login` and ensure you have admin access
- **Python script**: Verify your token has the correct scopes and hasn't expired

### Permission Errors

Ensure you have admin permissions on the repository. Only repository admins can create rulesets.

### Ruleset Already Exists

If a ruleset with the same name already exists, you'll get an error. You can either:
- Delete the existing ruleset via GitHub UI
- Modify the `name` field in `ruleset-config.json`

## API Documentation

For more information on GitHub repository rulesets, see:
- [GitHub Rulesets API Documentation](https://docs.github.com/en/rest/repos/rules)
- [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
