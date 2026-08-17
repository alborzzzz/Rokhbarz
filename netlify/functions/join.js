// Rokhbarz — opening-list notifier
// Receives {email, lang} from the site's join form and emails it to you via Resend.
// Setup (one time): Netlify → Site settings → Environment variables → add RESEND_API_KEY.
// Optional: RESEND_FROM (once rokhbarz.com is verified in Resend, e.g. "Rokhbarz <list@rokhbarz.com>")
//           NOTIFY_TO   (defaults to alborz@rokhbarz.com)

exports.handler = async (event) => {
  if (event.httpMethod !== "POST") {
    return { statusCode: 405, body: JSON.stringify({ ok: false, error: "POST only" }) };
  }

  let email = "", lang = "en";
  try {
    const b = JSON.parse(event.body || "{}");
    email = String(b.email || "").trim();
    lang = b.lang === "fr" ? "fr" : "en";
  } catch (e) {
    return { statusCode: 400, body: JSON.stringify({ ok: false, error: "bad json" }) };
  }

  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email) || email.length > 254) {
    return { statusCode: 400, body: JSON.stringify({ ok: false, error: "invalid email" }) };
  }

  const KEY = process.env.RESEND_API_KEY;
  if (!KEY) {
    return { statusCode: 500, body: JSON.stringify({ ok: false, error: "RESEND_API_KEY not set in Netlify environment variables" }) };
  }

  const FROM = process.env.RESEND_FROM || "Rokhbarz <onboarding@resend.dev>";
  const TO = process.env.NOTIFY_TO || "alborz@rokhbarz.com";
  const subject = lang === "fr" ? "Nouvelle inscription — liste d'ouverture (FR)" : "New opening-list signup (EN)";
  const when = new Date().toLocaleString("en-CA", { timeZone: "America/Toronto" });

  const html =
    `<div style="font-family:Georgia,serif;color:#241546;padding:8px 4px">
       <h2 style="margin:0 0 6px">New name for the list</h2>
       <p style="font-size:16px;margin:0 0 4px"><b>${email}</b></p>
       <p style="color:#5A4A7A;font-size:13px;margin:0">Page: ${lang.toUpperCase()} site · ${when} (Montréal)</p>
     </div>`;

  try {
    const r = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: "Bearer " + KEY },
      body: JSON.stringify({ from: FROM, to: [TO], subject, html }),
    });
    if (!r.ok) {
      const t = await r.text();
      return { statusCode: 502, body: JSON.stringify({ ok: false, error: "resend: " + t.slice(0, 200) }) };
    }
    return { statusCode: 200, body: JSON.stringify({ ok: true }) };
  } catch (e) {
    return { statusCode: 502, body: JSON.stringify({ ok: false, error: String(e).slice(0, 200) }) };
  }
};
