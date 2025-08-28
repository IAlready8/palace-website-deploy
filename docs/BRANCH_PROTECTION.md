Branch Protection Recommendations

Main Branch Rules
- Require pull request reviews before merging (at least 1 approval).
- Require status checks to pass before merging:
  - CI (build-and-test)
  - Deploy to GitHub Pages (optional, if you want to block on deploy)
- Require branches to be up to date before merging.
- Require signed commits (optional, if your org enforces it).
- Restrict who can push to matching branches (optional).

Status Checks to Enable
- GitHub Actions: CI (build-and-test)
- GitHub Actions: Deploy to GitHub Pages (optional)
- Optionally add a coverage threshold report step if you want minimum coverage.

How to Configure
1) Settings → Branches → Branch protection rules → Add rule
2) Branch name pattern: `main`
3) Select the options above and pick required status checks from the list.

Notes
- Our workflows treat ESLint warnings as errors during build (`CI=true`), so lint issues block merges.
- Release workflow runs on tags (`v*.*.*`) and does not require branch protection.
