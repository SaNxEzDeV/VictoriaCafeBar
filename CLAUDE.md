# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context

**Victoria Café Bar** (Cafetería Bar Victoria) — a live marketing website for a
café / bar / burger restaurant in **Torre del Mar, Málaga, Spain**.

It is a single-page static site (no framework, no build step) adapted from the
open-source **"Grilli"** restaurant template by *codewithsadee*. `index.txt` is
the original template's raw notes/readme kept for reference — it still contains
template placeholder content (e.g. `booking@grilli.com`) and is **not** part of
the live site.

- Design tokens (colours, typography, spacing) are documented in `@style-guide.md`.

### Business details (as shown on the site)
- **Address:** Calle el Copo, 30, 29740 Torre del Mar, Málaga
- **Hours:** 8 AM – 5:30 PM · 8 PM – 11:30 PM
- **Phone:** +34 654 497 318
- **Email:** victoriasmashburger@gmail.com
- **Instagram:** [@victoriasmash_](https://www.instagram.com/victoriasmash_/)

## Rules for Claude Code

- This is a **live production site** — treat content changes (prices, hours, menus, contact info) carefully.
- No build tooling: **edit `index.html` / `assets/css/style.css` / `assets/js/script.js` directly.** Do not introduce a bundler, npm, or a framework unless explicitly asked.
- Preserve the existing vanilla-JS + `data-*` attribute pattern (see below) — don't rewrite it into a library.
- Content is in **Spanish** — keep new copy in Spanish and match the existing tone.
- Commit messages: short, descriptive (repo history is informal — no strict convention).
- Remote is HTTPS (`github.com/SaNxEzDeV/VictoriaCafeBar`).

## Deployment

- **Production is hosted on IONOS** (domain + hosting). Deploying = uploading the
  site files to IONOS (FTP / File Manager / Deploy Now). **This is the real deploy path.**
- `.github/workflows/static.yml` publishes to **GitHub Pages** on push to `master`.
  This was set up **for testing only** and is **not** the production host — do not
  assume a `git push` updates the live site.

## Repo Structure

```
index.html            ← the entire site (single page, all sections)
index.txt             ← original "Grilli" template notes (reference only, not shipped)
style-guide.md        ← design tokens: colours, fonts, spacing, shadows, transitions
favicon.png
LICENSE
assets/
  css/style.css       ← all styles (~37 KB, hand-written, uses CSS custom properties)
  js/script.js        ← all behaviour (vanilla JS, ~170 lines)
  images/             ← ~50 images (hero, about, menu, events, gallery, logos)
  menus/              ← menu PDFs (see note below)
.github/workflows/
  static.yml          ← GitHub Pages test deploy (NOT production — see Deployment)
```

## Site Structure — `index.html`

Single page with anchor-nav sections: `#home`, `#about`, `#menu`
(`#desayuno`, `#tapas`, `#smash`), plus a Google Maps embed and footer.
Each menu block links to its PDF in `assets/menus/`.

### JavaScript — `assets/js/script.js`

Plain vanilla JS wired up via `data-*` attributes (no dependencies). Features:
- **Preloader** — hides once `window` `load` fires
- **Navbar toggle** — `[data-nav-toggler]` opens the mobile nav + overlay
- **Sticky / hide-on-scroll header** + **back-to-top button** (activate past 50px)
- **Hero slider** — `[data-hero-slider]`, prev/next buttons, auto-advances every 7s (pauses on button hover)
- **Mouse parallax** — `[data-parallax-item]` elements shift with cursor via `data-parallax-speed`

### External dependencies (CDN, loaded in `index.html`)
- **Google Fonts:** DM Sans + Forum
- **Ionicons 5.5.2** (unpkg) — the `<ion-icon>` elements
- **Google Maps** embed iframe (restaurant location)

## Menus (`assets/menus/`)

Three PDFs, linked from their menu sections:
- `menu-desayuno.pdf` — breakfast
- `menu-tapas.pdf` — tapas
- `menu-smash.pdf` — smash burgers

⚠️ **These PDFs are very large** (`menu-desayuno.pdf` ~34 MB, `menu-smash.pdf` ~14 MB).
They hurt load time and IONOS upload time. If touching menus, consider compressing/optimising them.

## Known rough edges (fix if asked)
- `<html lang="en">` but all content is Spanish — should be `lang="es"`.
- Oversized menu PDFs (see above).
- `index.txt` still holds leftover template placeholders — safe to ignore or delete.
