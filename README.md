


# How to start
  -cd /Users/d3/Desktop/palace-website-deploy/source/
  -npm start
  -Correct run path: /Users/d3/Desktop/palace-website-deploy/source/
  -Server will start on http://localhost



# Palace Website (React SPA)

 Modern, responsive single‑page application for a Palace‑inspired storefront. Built with React 18, React Router, and a lightweight design system. Ships as static assets suitable for Apache, Nginx, or any static host.

## Overview
- React SPA served as static files from the repo root.
- Source code lives in `source/` and builds to production assets.
- Client‑side routing via React Router with server fallback rules.
- Basic cart context included (needs integration across pages).
- Performance and SEO tuned for a static deploy.

## Repository Layout
- `index.html`: Production entry HTML used by the deployed site.
- `static/`: Production JS/CSS bundles used by `index.html`.
- `.htaccess`: Apache rules for SPA routing and caching.
- `start-local-server.sh`: Local static server for quick checks.
- `asset-manifest.json`: Build manifest for the deployed bundle.
- `source/`: React app source with its own `package.json` and build output under `source/build/`.

## Quick Start
- Static preview: `./start-local-server.sh` then open `http://localhost:8000`.
  - Note: This simple server does not support SPA rewrites for deep links (like `/product/1`).
    Use `npx serve -s .` for SPA-aware static serving locally.
- Develop from source:
  1) `cd source`
  2) `npm install`
  3) `npm start` (dev server at `http://localhost:3000`)
  4) `npm run build` (outputs to `source/build`)

## Build and Deploy
The production site is served from the repo root (`index.html`, `static/`). The `source/build/` folder is a local artifact and should not be deployed as-is.

Recommended deploy flow:
1) `cd source && npm ci && npm run build`
2) Copy `source/build/index.html` to repo root as `index.html`.
3) Copy `source/build/static/` to repo root `static/` (replace versioned bundles).
4) Verify `.htaccess` contains the SPA fallback and caching rules.
5) Upload root files to your server (Apache/Nginx) or your static host.

### GitHub Pages Deploy
A workflow is included to deploy `source/build` to GitHub Pages on pushes to `main`.
- Enable Pages in repo settings (Build and deployment → Source: GitHub Actions).
- Push to `main` and the site will be published.

### Release on Tags
Tagging `vX.Y.Z` triggers a build and GitHub Release with a zip of the production build.
- Create a tag: `git tag v1.0.0 && git push origin v1.0.0`
- Download `palace-website.zip` from the release assets.

SEO files included at root:
- `robots.txt`: Allows crawling and references `sitemap.xml`.
- `sitemap.xml`: Lists top-level SPA routes; consider generating product URLs if stable.

Nginx example:
```
location / {
  try_files $uri $uri/ /index.html;
}
```

Apache (`.htaccess`) is included and configured for SPA fallback and caching.

## Scripts (from `source/`)
- `npm start`: Run development server with hot reload.
- `npm run build`: Create production build in `source/build`.
- `npm test`: Run unit tests (once configured; see Roadmap).

## App Structure (source/src)
- `App.js`: Routes and layout (`Header`, `Footer`, `Routes`).
- `components/`: Shared UI (e.g., `Header`, `Footer`, `TriangleLogo`).
- `pages/`: Route pages (Home, WebShop, Product, Cart, etc.).
- `contexts/CartContext.js`: Cart state with localStorage persistence.
- `App.css`: Global styles and responsive rules.

## SPA Routing
Client routes:
- `/` Home
- `/webshop` Product listing with filters
- `/product/:id` Product detail
- `/cart` Cart
- `/shops`, `/jcc-plus`, `/advice`, `/about`, `/contact`, `/profile`

Server config must rewrite unknown paths to `index.html` (already in `.htaccess`).

## Accessibility and SEO
- Semantic HTML and clear focus states are encouraged.
- Meta tags present in `index.html` for description and social cards.
- Consider per‑route metadata (see Roadmap) and a sitemap/robots.

## Performance
- Bundles are fingerprinted and cacheable; server caching is enabled via `.htaccess`.
- Use image lazy‑loading and responsive sources when real images are added.
- Consider route‑level code‑splitting (see Roadmap).

## Security (Headers)
Enhanced Apache headers and caching are configured in `.htaccess`:
- Security: `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy` (CSP/HSTS commented for opt-in).
- Caching: immutable long cache for hashed assets; HTML served no-store.

## Roadmap: 10 Improvements With Safe Implementation Plans
1) Cart context integration across Header, Product, Cart
   - Plan: Replace local cart state in `pages/Cart.js` and alert‑based add‑to‑cart in `pages/Product.js` with `useCart()` from `contexts/CartContext.js`; update `components/Header.js` to render `CART (${getTotalItems()})` and re‑render on context changes; keep localStorage persistence. Validation: add an item and confirm count updates in Header and Cart totals; refresh and confirm state persists.

2) Centralize product catalog data
   - Plan: Create `source/src/data/products.js` exporting an array/map; consume it in `WebShop.js` and `Product.js` instead of hard‑coded arrays; add a small selector util to fetch by `id`. Validation: deep‑link `/product/3` and verify details and related products render.

3) URL‑driven filters in WebShop
   - Plan: Use `useSearchParams` for `category`, `price`, and optionally `size`; update URL on changes and initialize state from URL; preserve unknown params. Validation: reload after changing filters and confirm the same view restores; shareable URLs work.

4) Route‑level code splitting
   - Plan: Switch page imports in `App.js` to `React.lazy`; wrap `Routes` with `Suspense` using the existing loading spinner; verify bundle split in build. Validation: `source/build/static/js/` shows multiple chunks; navigation still works.

5) Accessibility pass (a11y)
   - Plan: Add `aria-label`s for buttons/links, ensure header menu toggle is keyboard accessible with correct `aria-expanded`; manage focus on route change; check color contrast for red on white; add skip‑to‑content link. Validation: Axe or Lighthouse a11y score ≥ 95; keyboard‑only navigation flows.

6) Per‑route SEO metadata
   - Plan: Add `react-helmet-async`; wrap app with provider; set titles/descriptions on key pages; generate `public/robots.txt` and a static `sitemap.xml` from known routes (or a simple script). Validation: View page source to confirm meta; test with Lighthouse SEO.

7) Service worker and PWA hygiene
   - Plan: If using Workbox, generate a `sw.js` at build and register it; otherwise remove the `sw.js` registration from `index.html` to avoid 404s; ensure `manifest.json` icons/fields are valid. Validation: Check network tab for service worker registration or absence of 404.

8) Testing setup
   - Plan: Add Jest + React Testing Library; write unit tests for `CartContext` (add/update/remove, totals) and `Header` cart badge; basic tests for `WebShop` filters; optional E2E smoke with Playwright/Cypress for add‑to‑cart flow. Validation: CI passes tests; manual smoke works.

9) CI/CD pipeline
   - Plan: GitHub Actions workflow to install, lint, test, build in `source/`; upload `build/` as artifact; optional deploy job to your server via SFTP/rsync or to a static host; protect `main` with required checks. Validation: PR shows green checks; on tag/main push, deploy step runs and site updates.

10) Build/deploy structure cleanup
   - Plan: Keep `source/build/` out of version control (add to `.gitignore`); standardize deploy so root `index.html` and `static/` are replaced from the latest build; remove drift between root and `source/build`; extend `.htaccess` with long‑cache for hashed assets and SPA 404 fallback. Validation: After deploy, bundle filenames match the latest build and no stale assets remain.

## Contributing
Pull requests are welcome. For meaningful changes, please include a brief description, screenshots of UI changes, and tests when applicable.

## License
No license specified.

## Docker (Nginx)
Build and run a container that serves the production build with Nginx.
- Build: `docker build -t palace-website .`
- Run: `docker run --rm -p 8080:80 palace-website`
- Open: `http://localhost:8080`

Nginx config lives at `docker/nginx.conf` and includes SPA fallback, caching, and basic security headers.


