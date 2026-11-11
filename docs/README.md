# Interactive portfolio — GitHub Pages

This is the original static site for **Mohamed Atef — Law × Technology**.

- [index.html](index.html) — page structure and accessible content
- [style.css](style.css) — responsive editorial design with light/dark themes and reduced-motion support
- [app.js](app.js) — project filters, theme toggle and reveal behavior
- [favicon.svg](favicon.svg) — original monogram
- [quality checker](../scripts/validate_portfolio.py) — offline checks for local links, semantics, reduced motion and SVG structure

## Verify locally

```bash
python3 scripts/validate_portfolio.py
node --check docs/app.js
```

Open `docs/index.html` in a browser. No build tools or external JavaScript libraries are required.

## GitHub Pages setup

The site is hosted from the `docs/` folder by [the official GitHub Actions workflow](../.github/workflows/portfolio.yml) after enabling **Settings → Pages → Build and deployment → Source: GitHub Actions**.

The workflow validates changes on every relevant push; when Pages is not enabled, deployment is intentionally skipped rather than claiming success. After enabling the setting, run the workflow manually from **Actions** to publish.

Intended URL after an actual successful deployment: `https://matef-hub.github.io/atefdodo/`. This URL must not be treated as live until the GitHub Pages deployment reports success.

## Integrity rules

- Project imagery is original abstract illustration, **not actual shipped UI screenshots**.
- No analytics tracking scripts, visitor trackers or secrets.
- Content and links describe repositories as they are documented; do not infer production certification.
- Use real, redacted screenshots only if checked in and explicitly labeled.

The public profile README is now live in [matef-hub/matef-hub](https://github.com/matef-hub/matef-hub). The interactive site is a separate GitHub Pages deployment.
