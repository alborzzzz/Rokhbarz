# ROKHBARZ — Going Live (Maison + Admin)
### ~25 minutes, no code. Do the steps in order.

What you're setting up:
- **Supabase** = your database + your login. Free tier.
- **maison/** = the public app (the walkable house), reads the database.
- **admin/** = your private office. Only your login gets in. Edit anything, see every member.

---

## Part 1 — Supabase (the database) · ~10 min

1. Go to **supabase.com** → Sign up (free) → **New project**.
   - Name: `rokhbarz` · set a strong database password (save it) · Region: **Canada (Central)**.
2. Wait ~1 minute for the project to build.
3. Left sidebar → **SQL Editor** → **New query** → open the file **schema.sql** (in this folder), copy ALL of it, paste, press **Run**.
   - You should see "Success". This creates the tables, the security rules, and fills in all your current menus, records, prints, flowers, and tiers.
4. **Lock the door — important.** Left sidebar → **Authentication** → **Sign In / Up (or Providers)**:
   - Under Email: turn **OFF "Allow new users to sign up"**. (Now nobody can ever create an account except you, below.)
5. Create YOUR account: **Authentication → Users → Add user → Create new user**.
   - Your email + a strong password. Tick **Auto-confirm**. This is your admin login.
6. Get your two keys: **Project Settings (gear) → API**:
   - Copy **Project URL** (looks like `https://xxxx.supabase.co`)
   - Copy the **anon / public** key (long string).
   - (Never share the `service_role` key — you won't need it.)

## Part 2 — Paste the keys into both apps · ~3 min

7. Open **maison/index.html** in any text editor (TextEdit / Notepad is fine).
   Near the bottom, find the CONFIG block and paste between the quotes:
   ```
   window.__SUPABASE_URL__ = "https://xxxx.supabase.co";
   window.__SUPABASE_ANON_KEY__ = "eyJhbGciOi...";
   ```
   Save.
8. Do the exact same in **admin/index.html**. Save.

> Each app is now two files — `index.html` (tiny, just config + page setup) and
> `bundle.js` (the whole app, pre-built). Always deploy both files together, in the
> same folder. Never deploy a `.jsx` file directly — browsers can't run it; `bundle.js`
> is the compiled, ready-to-run version.

> Is the anon key safe to be public? Yes — it's designed to be. Anyone with it can only do
> what the security rules allow: read the visible menu items, and sign the member book.
> Reading members or editing anything requires YOUR login.

## Part 3 — Deploy on Netlify · ~8 min

9. **The maison (public):** two options —
   - **Its own address (recommended):** app.netlify.com → **Add new site → Deploy manually** → drag the **maison** folder in. Then Site settings → **Domain management → Add domain** → `maison.rokhbarz.com` and follow the DNS step it shows (one CNAME record where you bought your domain).
   - **Or inside your current site:** put the maison folder (renamed exactly `maison`) inside your website folder next to index.html and fr/, and re-drag the whole site to your existing site's **Deploys** tab → it lives at `rokhbarz.com/maison`.
10. **The admin (private):** app.netlify.com → **Add new site → Deploy manually** → drag the **admin** folder in — as its OWN separate site, never inside the public one.
    - Optional: add domain `admin.rokhbarz.com`, or just keep the random `xxxx.netlify.app` address private to you.
    - The page is invisible to search engines and shows only a login. Without your Supabase password, it's a locked door.

## Part 4 — Test · ~4 min

11. Open the maison URL → walk to **The Café** → you should see your menu (now coming from the database).
12. Open the admin URL → log in with the account from step 5 → **Coffee** tab → change a price → **Save** → refresh the maison → the new price is live.
13. On the maison, go to **The Member's Book** → sign it with a test name → in admin, **Members** tab → your test signature is there. Delete it. Try **Export CSV**.
14. In the Listening Room, drop the needle → the Spotify player appears (previews for guests; full tracks for anyone logged into Spotify).

## Day-to-day
- **Change names/prices/descriptions:** admin → tab → edit → Save. Live instantly.
- **Add/remove items:** "+ Add item" / "Delete". Or un-tick "Visible" to hide without deleting.
- **Order on the page:** the "Order" number (1 shows first).
- **Members:** search, set status (new → contacted → member), keep notes, export CSV.

## If a page ever looks blank
This version is built to avoid that (the whole app is pre-compiled into `bundle.js`,
so it doesn't depend on external services just to appear). If it ever happens again:
open the page, right-click → **Inspect → Console tab**, and look for a red error —
that message tells you exactly what's wrong, and you can send it to me.

## Good to know (honest notes)
- Member emails are personal data — Quebec's **Law 25** applies. Keep a simple privacy note on the site and ask your lawyer once you start collecting for real.
- If you ever change your admin password: Supabase → Authentication → Users → your user → reset.
- Backups: Supabase keeps daily backups on paid tiers; on free, occasionally use admin → Export CSV (members) — the items you can always re-edit.
- These apps compile in the browser (simple by design). If the maison ever feels slow to first-load on weak connections, the next optimization is a pre-built bundle — say the word when it matters.
