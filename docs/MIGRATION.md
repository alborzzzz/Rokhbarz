# Migration — from dragging zips to a real workflow

**What you have now:** you download a zip from a chat and drag it into Netlify.
Desktop-only, no history, no undo, and a small edit costs a whole round trip.

**What you'll have after this:** the site lives in GitHub. You (or a Cursor agent,
from your phone) change a file, and Netlify publishes it automatically within a
minute. Every change is reversible.

**Time:** about an hour, once, at a desktop. After that you can work from your phone.

---

## Step 1 — Install the tools (15 min)

1. **Git** — macOS: open Terminal, type `git --version`, accept the install prompt.
   Windows: download from git-scm.com.
2. **GitHub account** — github.com, free. Pick a username you're happy with publicly.
3. **Cursor** — cursor.com/download. Sign in. Start on **Pro ($20/mo)** — don't buy up.
4. **Cursor for iOS** — App Store, "Cursor". Public beta, works on paid plans.
   It steers agents; it is not a phone code editor.

## Step 2 — Create the repository (10 min)

1. On github.com: **New repository** → name it `rokhbarz` → **Private** →
   *don't* add a README (we have one) → Create.
2. Unzip this package somewhere sensible, e.g. `~/Projects/rokhbarz`.
3. In Cursor: **File → Open Folder** → choose that folder.
4. Open Cursor's terminal (`Ctrl+``) and run, line by line:

```bash
git init
git add .
git commit -m "Rokhbarz: site, maison, admin, functions"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/rokhbarz.git
git push -u origin main
```

Refresh GitHub — your files are there. That is the last time you'll touch a zip.

> Keep the repo **private**. It contains your Supabase project URL and anon key.
> Those are safe to be public by design, but there's no reason to advertise them.

## Step 3 — Connect Netlify to GitHub (15 min)

**Site 1 — the public site (rokhbarz.com)**
1. Netlify → **Add new site → Import an existing project → GitHub** → pick `rokhbarz`.
2. Netlify reads `netlify.toml` automatically. Confirm it shows:
   - Publish directory: `public`
   - Functions directory: `netlify/functions`
3. Deploy. Then **Site configuration → Environment variables → Add**:
   - `RESEND_API_KEY` = your key from resend.com
4. **Domain management** → point `rokhbarz.com` here (if it currently points at your
   old drag-and-drop site, move the domain over and delete the old site afterwards).

**Site 2 — the admin (admin.rokhbarz.com)**
1. **Add new site → Import an existing project → GitHub** → pick `rokhbarz` **again**.
2. This time set **Base directory: `admin`** and **Publish directory: `admin`**.
3. Deploy, then add the subdomain `admin.rokhbarz.com` under Domain management.

Two sites, one repo. The admin never ships with the public site.

## Step 4 — Paste your keys (5 min)

In Cursor, open these and fill the config blocks near the bottom:

- `public/index.html` and `public/fr/index.html`
  - `window.__SUPABASE_URL__ = "https://gpcijwogszbqtxazcrue.supabase.co";`
    ← **bare URL, no `/rest/v1/`** (this was the cause of the old login error)
  - `window.__SUPABASE_ANON_KEY__ = "eyJ…";`
  - `window.__GA_ID__ = "G-XXXXXXXXXX";` (or leave blank to keep analytics off)
- `public/maison/index.html` — same Supabase pair
- `admin/index.html` — same Supabase pair

Then commit and push:

```bash
git add .
git commit -m "Add Supabase and analytics config"
git push
```

Netlify redeploys on its own. Watch it happen in the Deploys tab.

## Step 5 — Your new daily loop

**At a desk:** open Cursor → describe the change in the chat panel (Cmd+L) →
review the diff → commit and push. Live in ~60 seconds.

**On your phone:** open the Cursor app → pick the `rokhbarz` repo → launch an agent
("change the Patron tier to $180 in both English and French") → it works in the cloud →
you review the diff and merge → Netlify publishes.

**Rules of thumb**
- Small copy/price edits: fine from the phone.
- Anything structural, or touching the maison/admin bundles: do it at a desk.
- Never merge a diff you haven't actually read.

## Step 6 — Verify it worked (10 min)

- [ ] rokhbarz.com loads, EN and FR
- [ ] rokhbarz.com/maison/ loads and the rooms open
- [ ] admin.rokhbarz.com shows the login (and rokhbarz.com/admin does NOT)
- [ ] Join form: submit your own email → green ✓ → email arrives
- [ ] Change one word in Cursor, push, and see it live on the site
- [ ] Submit `https://rokhbarz.com/sitemap.xml` in Google Search Console

---

## Troubleshooting

**"Page not found" after deploy** — check Netlify's publish directory is `public`.

**Join form fails** — `RESEND_API_KEY` missing in Netlify env vars, or the whole
`netlify/` folder wasn't deployed. The form shows an honest error with your email
rather than a fake success, so nothing is lost.

**Admin login: "Invalid path specified in request URL"** — your Supabase URL has
`/rest/v1/` on the end. Use the bare project URL.

**Blank purple screen** — this was caused by runtime CDN loading; the bundles fix it.
If it ever returns, open the browser console (right-click → Inspect → Console) and
read the red error.

**Git asks for a password and rejects it** — GitHub needs a Personal Access Token,
not your password. GitHub → Settings → Developer settings → Personal access tokens →
Generate (repo scope). Use that as the password. Or install GitHub Desktop and avoid
the terminal entirely.
