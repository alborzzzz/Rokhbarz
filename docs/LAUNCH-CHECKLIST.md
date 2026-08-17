# Rokhbarz — pre-launch additions (what changed & what you must do)

## What's new in this build
- **Street address removed everywhere** (page text, meta tags, SEO schema, marquee).
  The site now says "Old Montreal / Vieux-Montréal" and the Visit section reads
  "the address is announced to the list first" — which is also a reason to sign up.
  ↳ Put the real address back once the lease is signed (say the word and I'll do it).
- **og-image.png (1200×630)** + og:image / twitter:image tags — links now preview properly
  on Instagram, iMessage, WhatsApp, LinkedIn, Slack.
- **FAQ section** (5 questions, EN + FR) with FAQPage structured data.
- **Sticky mobile CTA** — appears after the first screen, hides when the join form is visible.
- **Privacy pages** — /privacy.html and /fr/confidentialite.html (Law 25 oriented).
- **Custom 404** — /404.html and /fr/404.html, on brand.
- **robots.txt + sitemap.xml** — admin disallowed, both languages listed.
- **Google Analytics 4, consent-gated** — no cookies, no tracking until the visitor accepts.

## YOU MUST DO (2 minutes)
1. **Add your GA4 Measurement ID.** Open `index.html` AND `fr/index.html`, find:
       window.__GA_ID__ = "";
   and paste your ID: `window.__GA_ID__ = "G-XXXXXXXXXX";`
   Get it from analytics.google.com → Admin → Data Streams → your web stream.
   **Leave it blank and analytics stays off and no banner appears** — that's a valid choice too.
2. **Deploy the whole folder** (index.html, fr/, netlify/, og-image.png, robots.txt,
   sitemap.xml, 404.html, privacy.html). Netlify serves 404.html automatically.
3. **After deploying**, submit `https://rokhbarz.com/sitemap.xml` in Google Search Console.

## Notes
- The privacy pages are written to be honest and readable, and they reflect Law 25's
  main requirements (purpose, consent, third parties, retention, your rights, contact).
  They are **not legal advice** — have a Québec lawyer review before you collect at scale.
- Skipped deliberately: map/directions (no signed address), reviews (no customers yet),
  case studies (not that kind of business), breadcrumbs (single-page site), team photo
  (you chose to stay anonymous).
