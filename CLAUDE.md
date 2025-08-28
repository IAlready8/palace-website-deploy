# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Palace-inspired website built as a React Single Page Application (SPA) with both development source code (`source/`) and pre-built deployment files for static hosting. The project has evolved beyond the original Palace template to include portfolio features, advanced theming, and chat functionality.

## Development Commands

### Primary Development (source/ directory)
```bash
cd source

# Development
npm install                   # Install dependencies
npm start                     # Start development server (port 3000)

# Building & Testing  
npm run build                 # Build for production (outputs to source/build/)
npm test                      # Run Jest tests with coverage
npm test -- --watch           # Run tests in watch mode
npm test -- --testNamePattern="specific test" # Run specific test
npm run analyze               # Build and serve with bundle analysis
npm run lint                  # ESLint with auto-fix

# Custom Deployment
npm run deploy                # Build and copy to deployment directory
```

### Static Server Testing
```bash
# From root directory - serves the built static files
./start-local-server.sh       # Python-based local server on port 8000
npx serve -s .               # SPA-aware static serving (recommended for testing)
```

## Project Architecture

### Technology Stack
- **Frontend**: React 18 with React Router DOM v6
- **Build Tool**: Create React App (CRA) with React Scripts 5.0.1
- **Routing**: Client-side routing with React Router
- **Context Management**: React Context for Cart, Theme, and Database state
- **Styling**: CSS with dynamic theming system
- **Performance**: Service Worker, Web Vitals monitoring
- **Testing**: Jest with React Testing Library

### Application Structure

**Core Architecture:**
- `App.js` - Main application with lazy-loaded routes and context providers
- `index.js` - App bootstrap with performance monitoring and service worker
- `contexts/` - React Context providers for global state management
- `components/` - Reusable UI components with advanced features
- `pages/` - Route-level components (code-split)
- `hooks/` - Custom React hooks for analytics, performance, etc.

**Key Features:**
- **Dynamic Theming**: Page-based color schemes with dark mode support
- **Cart System**: Persistent localStorage-backed shopping cart
- **Performance Monitoring**: Web Vitals tracking and bundle analysis
- **Service Worker**: PWA capabilities with offline support
- **Chat Widget**: Integrated chat system
- **Responsive Design**: Mobile-first with micro-interactions

### Routing Configuration

Main routes (with theme-aware navigation):
- `/` - Home (Palace Red theme)
- `/projects` - Project showcase (Electric Purple theme)
- `/skills` - Skills display (Emerald Green theme)
- `/experiments` - Experimental features (Ocean Blue theme)
- `/about` - About page (Sunset Orange theme)
- `/contact` - Contact information (Rose Pink theme)
- `/webshop` - Product catalog (Gold Rush theme)
- `/product/:id` - Dynamic product pages (Product Crimson theme)
- `/cart` - Shopping cart (Lime Zest theme)
- `/loyalty` - Loyalty dashboard
- `/checkout` - Checkout process

### Context Architecture

**ThemeContext (`contexts/ThemeContext.js`):**
- Page-based theme switching with 10+ predefined color schemes
- Dark mode toggle with localStorage persistence
- CSS custom properties for dynamic styling
- Smooth transitions between themes
- Meta theme-color updates for mobile browsers

**CartContext (`contexts/CartContext.js`):**
- localStorage-backed cart persistence
- Size/quantity management
- Price calculations and item totals
- Add/update/remove operations

**DatabaseContext (`contexts/DatabaseContext.js`):**
- Data management layer for products and user state

### Component System

**Advanced Components:**
- `ErrorBoundary` - Application-level error handling
- `ChatWidget` - Integrated chat functionality
- `ThemeColorPicker` - Dynamic theme selection
- `ScrollAnimations` - Intersection Observer-based animations
- `MicroInteractions` - Enhanced user feedback
- `LazyImage` - Performance-optimized image loading
- `SkeletonLoader` - Loading state improvements

**Core Components:**
- `Header` - Navigation with cart integration
- `Footer` - Site footer
- `TriangleLogo` - Configurable logo component

### Performance Features

**Bundle Optimization:**
- Code splitting at route level with React.lazy()
- Service worker for offline functionality
- Resource hints and preloading
- Bundle analysis tools
- Web Vitals monitoring

**Custom Hooks:**
- `useAnalytics` - User behavior tracking
- `useDocumentMeta` - Dynamic meta tags
- `useKeyboardShortcuts` - Accessibility shortcuts
- `useIntersectionObserver` - Scroll-based animations
- `useProducts` - Product data management
- `useVirtualization` - Performance for large lists

### Data Management

**Product Catalog (`data/products.js`):**
- Centralized product data with 12 sample products
- Categories: clothing, skateboards, footwear, accessories
- Size variants and pricing
- Image arrays for product galleries
- SKU tracking

**Utilities:**
- `cart.js` - Cart calculation utilities
- `filters.js` - Product filtering logic
- `performance.js` - Web Vitals reporting
- `bundleAnalyzer.js` - Performance analysis tools

## Deployment Architecture

The repository contains both source code and deployment-ready build:
- `source/` - Development source code
- Root level files - Pre-built static files for hosting
- `static/` - Built CSS and JS assets with content hashing
- `index.html` - SPA entry point with fallback routing
- `asset-manifest.json` - Build asset mapping

### Server Configuration Requirements

For proper SPA routing, the server must redirect all non-file requests to `index.html`:

**Apache (.htaccess included):**
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]
```

**Nginx:**
```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

## Development Notes

### Code Patterns
- Functional components with React hooks
- Context-based state management (no Redux)
- CSS custom properties for theming
- Performance-first loading strategies
- Responsive design with mobile-first approach
- Error boundaries for graceful degradation

### Testing Architecture
- Jest configuration with coverage reporting
- React Testing Library for component tests
- Test files in `__tests__/` directories
- Coverage reports generated in `coverage/`

### Build Process
- CRA build system with custom optimizations
- Source maps disabled for production
- Inline runtime chunk disabled for better caching
- Static asset fingerprinting for cache busting

## Key Files for Development

**Essential Configuration:**
- `source/package.json` - Dependencies and scripts
- `source/src/App.js` - Main application structure
- `source/src/contexts/` - Global state management
- `source/src/data/products.js` - Product catalog

**Styling:**
- `source/src/App.css` - Global styles and responsive rules
- `source/src/components/TriangleLogo.css` - Logo component styles
- CSS custom properties for dynamic theming

**Performance:**
- `source/src/utils/performance.js` - Web Vitals monitoring
- `source/src/utils/bundleAnalyzer.js` - Bundle analysis
- `source/public/sw.js` - Service worker configuration

## Critical Development Patterns

### Working with Themes
When adding new routes, update `pageThemes` in `contexts/ThemeContext.js` to assign a unique color scheme. Themes automatically apply via CSS custom properties (`--theme-primary`, `--theme-background`, etc.).

### Cart Integration
Components should use `const { addToCart, cartItems, getTotalItems } = useCart()` for cart operations. Cart state persists automatically via localStorage.

### Adding New Products  
Update `data/products.js` with the product object structure including `id`, `name`, `price`, `category`, `sizes`, `images`, and `sku`.

### Performance Considerations
- New page components should use `lazy()` imports in `App.js`
- Images should use the `LazyImage` component for performance
- Heavy operations should be wrapped in `useMemo` or `useCallback`

## Common Issues & Solutions

### SPA Routing Problems
If deep links fail in production, verify server redirects all routes to `index.html` (see Server Configuration section).

### Theme Not Updating  
Check that new routes are added to `pageThemes` object and CSS uses custom properties like `var(--theme-primary)`.

### Cart State Lost
Cart uses localStorage with key `palaceCart`. Issues usually relate to JSON serialization of complex objects.

## Important Implementation Details

- Product data is currently hardcoded but structured for easy API integration
- Cart functionality is fully implemented with localStorage persistence  
- Theme system supports both light and dark modes with smooth transitions
- All routes are code-split for optimal loading performance
- Service worker provides offline capability and caching strategies
- The app is PWA-ready with manifest and proper meta tags
- Working directory for development commands is `source/` (not root)