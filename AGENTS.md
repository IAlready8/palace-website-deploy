# Repository Guidelines

## Project Structure & Module Organization
- Root serves production assets: `index.html`, `static/`, `sw.js`, `.htaccess`.
- App source lives in `source/` (React 18 + CRA): `source/src/{components,pages,contexts,hooks,utils,data}`.
- Tests live in `source/src/__tests__/`.
- Docker + Nginx config under `docker/` and `Dockerfile`.

## Build, Test, and Development Commands
- Dev server: `cd source && npm start` (http://localhost:3000).
- Install deps: `cd source && npm ci` (or `npm install`).
- Build prod: `cd source && npm run build` (outputs to `source/build`).
- Unit tests + coverage: `cd source && npm test`.
- Lint (autofix): `cd source && npm run lint`.
- Static preview of built site from repo root: `./start-local-server.sh` (simple server; no SPA rewrites).

## Coding Style & Naming Conventions
- Linting: CRA ESLint config (`react-app`, `react-app/jest`). Fix issues before PRs.
- Components: PascalCase files in `source/src/components` (e.g., `TriangleLogo.js`).
- Hooks: `useX` naming in `source/src/hooks` (e.g., `useProducts.js`).
- Contexts: `XContext.js` in `source/src/contexts` (e.g., `CartContext.js`).
- Utilities/data: camelCase exports in `source/src/{utils,data}`.
- Prefer functional components, hooks, and module‑scoped CSS in `App.css`/component styles.

## Testing Guidelines
- Framework: Jest via `react-scripts`. Tests in `source/src/__tests__/` as `*.test.js`.
- Aim to cover cart logic, filters, and critical UI states. Keep coverage from regressing.
- Run `npm test` locally and ensure it passes in CI.

## Commit & Pull Request Guidelines
- Use Conventional Commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `ci:`, `chore:` (see Git history).
- PRs must include: clear description, linked issue (if any), screenshots/GIFs for UI changes, and notes on testing.
- Keep changes scoped; update docs when behavior or commands change.

## Security & Configuration Tips
- SPA routing fallback and security headers are in `.htaccess`; for Nginx see `docker/nginx.conf`.
- Deploy by replacing root `index.html` and `static/` with the latest `source/build/` outputs. Example: `cd source && npm ci && npm run build` then copy `build/index.html` and `build/static/` to repo root.

## Architecture Overview
- React SPA using React Router for routes (`App.js`), with shared UI in `components/` and route pages in `pages/`.
- State via contexts: `CartContext`, `ThemeContext`, optional `DatabaseContext`; custom hooks for products/analytics.
- Data and logic in `utils/` and `data/`; API stubs live under `services/api.js`.
- Performance and SEO helpers in `utils/performance.js` and `components/SEOHead.js`.

Key files:
- `source/src/App.js` (routes/layout), `source/src/index.js` (bootstrap)
- `source/src/contexts/CartContext.js`, `source/src/contexts/ThemeContext.js`
- `source/src/hooks/useProducts.js`, `source/src/hooks/useAnalytics.js`
- `source/src/services/api.js`, `source/src/utils/filters.js`, `source/src/utils/cart.js`
- `source/src/components/Header.js`, `source/src/components/SEOHead.js`

## CI/CD
- CI (`.github/workflows/ci.yml`): on pushes/PRs to `main/master` runs Node 20, installs in `source/`, runs tests with coverage, builds, and uploads `build` and coverage artifacts.
- Pages Deploy (`deploy-pages.yml`): on `main` pushes builds `source/` and deploys `source/build` to GitHub Pages.
- Release (`release.yml`): on tags `v*.*.*` runs tests/build, zips `source/build` as `palace-website.zip`, and creates a GitHub Release with artifacts.

## Local Deploy Checklist
1) Build: `cd source && npm ci && npm run build`.
2) Promote build to root: copy `source/build/index.html` → `index.html`; copy `source/build/static/` → `static/`.
3) Verify SPA rewrites: `.htaccess` (Apache) or `docker/nginx.conf` (Nginx) has `try_files ... /index.html`.
4) Sanity check locally: `./start-local-server.sh` and open `http://localhost:8000`.
5) Optional: use GitHub Pages workflow by pushing to `main`.

## Branching & Release
- Default branch: `main`. Open PRs from topic branches; require green CI.
- Branch names: `feature/<short-desc>`, `fix/<short-desc>`, `chore/<short-desc>`; include issue ID if applicable, e.g., `feature/123-cart-badge`.
- Version tags: semantic `vX.Y.Z` triggers the Release workflow and packages the build.
- Tag example: `git tag v1.2.3 && git push origin v1.2.3`.
- Release notes: summarize key changes by scope (features, fixes, chores); link PRs/issues.
