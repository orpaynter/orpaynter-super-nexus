#!/bin/bash

# Branch Protection Ruleset Setup Script
# This script creates a comprehensive branch protection ruleset for the main branch
# using the GitHub CLI and REST API.

set -e

REPO="orpaynter/orpaynter-super-nexus"

echo "Creating branch protection ruleset for $REPO..."

# Check if gh CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated. Please run 'gh auth login'"
    exit 1
fi

# Create the ruleset
# Note: Rules work together in GitHub rulesets:
# - The 'update' rule blocks direct pushes
# - The 'pull_request' rule creates an exception allowing PR-based updates
# - The 'creation' rule prevents creating new branches matching the pattern
if gh api repos/$REPO/rulesets --method POST --input - <<'EOF'
{
  "name": "main-branch-protection",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [],
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    { "type": "creation" },
    { "type": "update" },
    { "type": "deletion" },
    { "type": "required_linear_history" },
    { "type": "required_signatures" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true
      }
    },
    { "type": "non_fast_forward" }
  ]
}
EOF
then
    echo "✓ Branch protection ruleset created successfully!"
else
    echo "Error: Failed to create ruleset. This may happen if:"
    echo "  - The ruleset already exists (try deleting it first)"
    echo "  - You don't have admin permissions on the repository"
    echo "  - The repository name is incorrect"
    exit 1
fi
