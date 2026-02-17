#!/usr/bin/env python3

"""
Script to create GitHub repository ruleset for main branch protection
Uses GitHub REST API to create a ruleset with enterprise-grade settings

Prerequisites:
    - Python 3.6 or higher
    - requests library (pip install requests)
    - GitHub personal access token with 'repo' and 'admin:repo_hook' scopes

Usage:
    export GITHUB_TOKEN=your_token_here
    python3 scripts/setup-ruleset.py
    
    Or provide token via command line:
    python3 scripts/setup-ruleset.py --token your_token_here
"""

import json
import os
import sys
import argparse
from pathlib import Path

try:
    import requests
except ImportError:
    print("❌ Error: 'requests' library is not installed.")
    print("   Please install it: pip install requests")
    sys.exit(1)

REPO_OWNER = "orpaynter"
REPO_NAME = "orpaynter-super-nexus"
API_BASE_URL = "https://api.github.com"


def load_config(config_path):
    """Load the ruleset configuration from JSON file"""
    try:
        with open(config_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"❌ Error: Configuration file not found: {config_path}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"❌ Error: Invalid JSON in configuration file: {e}")
        sys.exit(1)


def create_ruleset(token, config):
    """Create the repository ruleset via GitHub API"""
    url = f"{API_BASE_URL}/repos/{REPO_OWNER}/{REPO_NAME}/rulesets"
    
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28"
    }
    
    response = requests.post(url, headers=headers, json=config)
    
    return response


def main():
    parser = argparse.ArgumentParser(
        description="Create GitHub repository ruleset for main branch protection"
    )
    parser.add_argument(
        "--token",
        help="GitHub personal access token (or set GITHUB_TOKEN env var)",
        default=os.environ.get("GITHUB_TOKEN")
    )
    parser.add_argument(
        "--config",
        help="Path to ruleset configuration JSON file",
        default=None
    )
    
    args = parser.parse_args()
    
    # Get GitHub token
    token = args.token
    if not token:
        print("❌ Error: GitHub token not provided.")
        print("   Set GITHUB_TOKEN environment variable or use --token flag")
        sys.exit(1)
    
    # Get config file path
    if args.config:
        config_path = Path(args.config)
    else:
        script_dir = Path(__file__).parent
        config_path = script_dir / "ruleset-config.json"
    
    print(f"🔒 Setting up GitHub repository ruleset for {REPO_OWNER}/{REPO_NAME}")
    print()
    
    # Load configuration
    print(f"📋 Loading configuration from: {config_path}")
    config = load_config(config_path)
    
    # Display configuration
    print()
    print("📝 Ruleset configuration:")
    print(json.dumps(config, indent=2))
    print()
    
    # Confirm before proceeding
    confirmation = input("Do you want to create this ruleset? (y/n) ")
    if confirmation.lower() != 'y':
        print("❌ Aborted by user")
        sys.exit(0)
    
    # Create the ruleset
    print()
    print("🚀 Creating ruleset...")
    response = create_ruleset(token, config)
    
    if response.status_code == 201:
        print("✅ Ruleset created successfully!")
        print()
        print("Ruleset details:")
        print(json.dumps(response.json(), indent=2))
        print()
        print("🎉 Main branch protection is now active with enterprise-grade settings!")
    else:
        print(f"❌ Failed to create ruleset (HTTP {response.status_code}):")
        print(response.text)
        sys.exit(1)


if __name__ == "__main__":
    main()
