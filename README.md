# Rokhbarz

A members' café and hi-fi vinyl listening room in Old Montreal. Opening 2026.
Dual brand: **Maison Coccinelle** (the space) · **Rokh Barz** (the voice).

**New here? Read [`docs/MIGRATION.md`](docs/MIGRATION.md) first** — it sets up
GitHub, Cursor and Netlify end to end.

---

## Structure

```
public/                    → Netlify site #1  (rokhbarz.com)
  index.html                 EN marketing site — single file, inline CSS/JS, base64 art
  fr/index.html              FR mirror (keep in sync)
  privacy.html               EN privacy (Québec Law 25)
  fr/confidentialite.html    FR privacy
  404.html, fr/404.html      custom error pages
  robots.txt, sitemap.xml, og-image.png
  maison/                    the "walkable house" app (index.html + pre-built bundle.js)

netlify/functions/join.js  → join form → Resend email to alborz@rokhbarz.com

admin/                     → Netlify site #2  (admin.rokhbarz.com) — SEPARATE, private
  index.html + bundle.js     login-gated dashboard: edit collections, manage members

docs/
  MIGRATION.md               ← start here
  SUPABASE-SETUP.md          database + auth setup
  JOIN-SETUP.md              Resend / join form setup
  LAUNCH-CHECKLIST.md        what shipped in the pre-launch pass
  schema.sql                 paste into Supabase SQL editor
```

## Two sites, one repo

| Site | Netlify base | Publish | Domain |
|---|---|---|---|
| Public | *(root)* | `public` | rokhbarz.com |
| Admin | `admin` | `admin` | admin.rokhbarz.com |

The admin must never deploy inside the public site. `robots.txt` disallows `/admin`
and `netlify.toml` 404s that path as a second line of defence.

## Configuration

No build step. Config lives in `window.__*__` blocks near the bottom of each HTML file:

| Variable | Where | Notes |
|---|---|---|
| `__SUPABASE_URL__` | public, maison, admin | **Bare** project URL — no `/rest/v1/` |
| `__SUPABASE_ANON_KEY__` | public, maison, admin | Safe to be public (RLS enforces access) |
| `__GA_ID__` | public EN + FR | Blank = analytics off, no consent banner |
| `RESEND_API_KEY` | **Netlify env vars only** | Never in the repo |

## Conventions

- **Bilingual:** every user-facing change lands in EN *and* FR.
- **No street address** until the lease is signed — "Old Montreal" only.
- **Email:** `alborz@rokhbarz.com`.
- **Bundles are build artifacts:** don't hand-edit `maison/bundle.js` or
  `admin/bundle.js`. Change source and rebuild.
- Design tokens and voice rules live in [`.cursorrules`](.cursorrules) — Cursor reads
  that automatically, so agents produce Rokhbarz-looking work instead of generic UI.

## Common tasks

```bash
# preview locally
cd public && python3 -m http.server 8000     # → localhost:8000

# ship a change
git add . && git commit -m "what changed" && git push
```

## Status

- ✅ Site live (EN/FR), maison app, admin panel, join form, privacy, SEO
- ⏳ Lease not signed — address withheld sitewide
- ⏳ Real photography pending (gallery uses placeholders)
- ⏳ Membership pricing under review after market validation
