#!/bin/bash

# Script to create GitHub repository ruleset for main branch protection
# Uses GitHub CLI (gh) to interact with the GitHub REST API
# 
# Prerequisites:
#   - GitHub CLI (gh) must be installed
#   - Must be authenticated with gh (run: gh auth login)
#   - Must have admin permissions on the repository
#
# Usage:
#   ./scripts/setup-ruleset.sh

set -e

REPO_OWNER="orpaynter"
REPO_NAME="orpaynter-super-nexus"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/ruleset-config.json"

echo "🔒 Setting up GitHub repository ruleset for $REPO_OWNER/$REPO_NAME"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed."
    echo "   Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Error: Not authenticated with GitHub CLI."
    echo "   Please run: gh auth login"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

echo "📋 Configuration file: $CONFIG_FILE"
echo ""

# Display the ruleset configuration
echo "📝 Ruleset configuration:"
cat "$CONFIG_FILE" | jq '.'
echo ""

# Confirm before proceeding
read -p "Do you want to create this ruleset? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted by user"
    exit 0
fi

# Create the ruleset using GitHub API
echo "🚀 Creating ruleset..."
RESPONSE=$(gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$REPO_OWNER/$REPO_NAME/rulesets" \
    --input "$CONFIG_FILE" 2>&1)

if [ $? -eq 0 ]; then
    echo "✅ Ruleset created successfully!"
    echo ""
    echo "Ruleset details:"
    echo "$RESPONSE" | jq '.'
    echo ""
    echo "🎉 Main branch protection is now active with enterprise-grade settings!"
else
    echo "❌ Failed to create ruleset:"
    echo "$RESPONSE"
    exit 1
fi
