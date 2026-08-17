# Join form → your inbox (Resend) · 5-minute setup

The "Join the list" form now sends every signup to your email through Resend,
via a tiny server function included in this folder (`netlify/functions/join.js`).
The visitor sees a green ✓ confirmation when it sends.

## One-time setup

1. **Get your Resend API key** — resend.com → API Keys → Create (or reuse the one
   from your maison stack). Copy it.

2. **Add it to Netlify** — your site → Site configuration → **Environment variables**
   → Add variable:
   - Key: `RESEND_API_KEY` · Value: (paste the key)

3. **Deploy the whole folder** — this deploy must include the `netlify/` folder
   next to `index.html` and `fr/`. Drag the entire site folder (not just the two
   HTML files) into Netlify → Deploys. Netlify picks up the function automatically.

4. **Test** — open the site, scroll to the join form, enter your own email, press
   Join. You should see the green ✓, and within seconds an email titled
   "New opening-list signup" in your inbox.

## Optional (recommended once)

- **Send from your own domain**: after you verify `rokhbarz.com` in Resend
  (Domains → Add), add a second Netlify variable:
  - `RESEND_FROM` = `Rokhbarz <list@rokhbarz.com>`
  Until then it sends from Resend's default onboarding address, which is fine
  for notifications to yourself.
- `NOTIFY_TO` — set only if you ever want signups sent somewhere other than
  alborz@rokhbarz.com.

## Honest notes

- If the function isn't deployed or the key is missing, the visitor sees a clear
  message with your email address instead of a fake success — nothing is silently lost.
- Signups also still land in your Supabase members table (admin → Members) if the
  site's Supabase config is filled in, so the inbox email and the database entry
  back each other up.
