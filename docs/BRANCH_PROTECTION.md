# Branch Protection Ruleset

This document describes the branch protection ruleset configured for the `main` branch of the `orpaynter/orpaynter-super-nexus` repository.

## Overview

The main branch is protected by a comprehensive ruleset that ensures code quality, security, and proper review processes. The ruleset is named `main-branch-protection` and is actively enforced.

## Protection Rules

### 1. No Direct Pushes to Main (PR Required)

**Rule Type:** `update`

Direct pushes to the main branch are blocked. All changes must be submitted via pull requests.

**Why:** Ensures all code changes go through the review process before being merged.

### 2. Pull Request Requirements

**Rule Type:** `pull_request`

Pull requests must meet the following criteria:
- **1 approval required** - At least one approving review is needed before merging
- **Stale reviews dismissed on new pushes** - New commits invalidate previous approvals, ensuring reviewers see the latest changes
- **All review conversations must be resolved** - No pending comments or discussions can remain unaddressed
- **Code owner review:** Not required (but code owners are defined in `.github/CODEOWNERS`)
- **Last push approval:** Not required

**Why:** Maintains code quality through peer review and ensures all feedback is addressed.

### 3. Linear History Enforced

**Rule Type:** `required_linear_history`

Merge commits are not allowed; only fast-forward merges or rebase merges are permitted.

**Why:** Maintains a clean, linear commit history that is easier to understand and navigate.

### 4. Signed Commits Required

**Rule Type:** `required_signatures`

All commits must be cryptographically signed (GPG or S/MIME).

**Why:** Verifies commit authenticity and ensures commits come from verified sources.

### 5. Force Pushes Blocked

**Rule Type:** `non_fast_forward`

Force pushes (git push --force) to the main branch are prevented.

**Why:** Protects the branch history from being rewritten, which could cause data loss or confusion.

### 6. Branch Deletion Blocked

**Rule Type:** `deletion`

The main branch cannot be deleted.

**Why:** Prevents accidental deletion of the primary branch.

### 7. Branch Creation Restricted

**Rule Type:** `creation`

Only authorized users can create branches matching the protected pattern.

**Why:** Controls who can create branches in the protected namespace.

## Rules Summary

| Rule | Purpose |
|------|---------|
| `creation` | Restrict who can create matching refs |
| `update` | Restrict direct pushes |
| `deletion` | Prevent branch deletion |
| `required_linear_history` | Clean commit history |
| `required_signatures` | Verify commit authenticity |
| `pull_request` | Require PR with 1 approval, dismiss stale reviews, require conversation resolution |
| `non_fast_forward` | Block force pushes |

## Bypass Actors

Currently, there are no bypass actors configured. This means all contributors, including repository administrators, must follow these rules.

## Setup

To apply this ruleset to a repository, run the setup script:

```bash
./scripts/setup-ruleset.sh
```

**Prerequisites:**
- GitHub CLI (`gh`) must be installed and authenticated
- User must have admin permissions on the repository

## Code Owners

Default code ownership is defined in `.github/CODEOWNERS`:
- `@orpaynter` is the default owner for all files

## Contributing

When contributing to this repository:

1. Create a feature branch from `main`
2. Make your changes and commit them with signed commits
3. Push your branch and create a pull request
4. Ensure all review conversations are resolved
5. Obtain at least 1 approval
6. Merge using rebase or fast-forward to maintain linear history

## Additional Resources

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Signing Commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- [Code Owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
