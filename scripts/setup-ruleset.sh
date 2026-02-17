#!/bin/bash

# Branch Protection Ruleset Setup Script
# This script creates a comprehensive branch protection ruleset for the main branch
# using the GitHub CLI and REST API.

set -e

REPO="orpaynter/orpaynter-super-nexus"

echo "Creating branch protection ruleset for $REPO..."

gh api repos/$REPO/rulesets --method POST --input - <<'EOF'
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

echo "✓ Branch protection ruleset created successfully!"
