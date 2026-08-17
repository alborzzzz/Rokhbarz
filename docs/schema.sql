-- ══════════════════════════════════════════════════════════════
-- ROKHBARZ — Live data schema (paste ALL of this into
-- Supabase → SQL Editor → New query → Run)
-- Creates: items (all collections) + members, security rules,
-- and seeds every current collection so you start populated.
-- ══════════════════════════════════════════════════════════════

-- ── Tables ─────────────────────────────────────────────────────
create table if not exists public.items (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  collection  text not null,            -- coffee | food | vinyl | issues | prints | shop_vinyl | flowers | tiers
  name        text not null,
  subtitle    text,                     -- tag / artist / season / edition / tier price-line
  description text,
  price       numeric,
  extra       jsonb not null default '{}'::jsonb,  -- collection-specific fields
  sort_order  int  not null default 100,
  active      boolean not null default true
);

create table if not exists public.members (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text not null,
  email       text not null,
  tier        text default 'founding interest',
  status      text not null default 'new',   -- new | contacted | member | declined
  notes       text default ''
);

create index if not exists items_collection_idx on public.items (collection, sort_order);
create index if not exists members_created_idx  on public.members (created_at desc);

-- ── Security (Row Level Security) ──────────────────────────────
alter table public.items   enable row level security;
alter table public.members enable row level security;

-- Anyone may READ active items (the maison site needs this)
drop policy if exists items_public_read on public.items;
create policy items_public_read on public.items
  for select using (active = true or auth.role() = 'authenticated');

-- Only a signed-in user (you) may write items
drop policy if exists items_admin_write on public.items;
create policy items_admin_write on public.items
  for all to authenticated using (true) with check (true);

-- Anyone may INSERT a member (the "Sign the book" form)…
drop policy if exists members_public_insert on public.members;
create policy members_public_insert on public.members
  for insert to anon, authenticated with check (true);

-- …but only a signed-in user (you) may read / edit / delete them
drop policy if exists members_admin_read on public.members;
create policy members_admin_read on public.members
  for select to authenticated using (true);
drop policy if exists members_admin_update on public.members;
create policy members_admin_update on public.members
  for update to authenticated using (true);
drop policy if exists members_admin_delete on public.members;
create policy members_admin_delete on public.members
  for delete to authenticated using (true);

-- ── Seed: current Rokhbarz content ─────────────────────────────
-- (Safe to run once. Running twice would duplicate rows.)

insert into public.items (collection, name, subtitle, description, price, extra, sort_order) values
-- coffee
('coffee','The Rokh','House signature','Espresso drawn over cardamom, rose, and honey — served slowly, and with intent.',7,'{"notes":"Cardamom · Rose · Honey"}',1),
('coffee','Espresso','Single origin','A rotating roaster, pulled with intention. The house benchmark.',4,'{"notes":"Rotating origin"}',2),
('coffee','Cortado','Equal parts','Espresso and warm milk in perfect balance. Small, honest, exact.',5,'{"notes":"4 oz · velvet"}',3),
('coffee','Filter — pour-over','Daily selection','One coffee, chosen each morning, brewed to order by hand.',6,'{"notes":"Brewed to order"}',4),
('coffee','Cappuccino','Six ounces','Velvet microfoam over a full-bodied shot. Never rushed.',5,'{"notes":"Microfoam · 6 oz"}',5),
('coffee','Cezve','The old way','Finely ground coffee in the copper pot, unfiltered, with a date on the side.',8,'{"notes":"Copper pot · unfiltered"}',6),
-- food
('food','Butter croissant',null,'Laminated in-house, baked each morning.',5,'{"notes":"Daily · 7am"}',1),
('food','Pistachio escargot',null,'Orange-blossom, toasted pistachio, a slow spiral.',7,'{"notes":"House favourite"}',2),
('food','Saffron financier',null,'Brown butter, almond, saffron — Persia in a bite.',4.5,'{"notes":"Gluten-light"}',3),
('food','Chocolate & tahini cookie',null,'Dark chocolate, sesame, sea salt.',4,'{"notes":"Baked at noon"}',4),
('food','Rosewater mille-feuille',null,'A thousand leaves, cream perfumed with rose.',9,'{"notes":"Weekends"}',5),
('food','The evening board',null,'Cheese, preserves, warm bread — for the listening hours.',24,'{"notes":"After dark"}',6),
-- vinyl (played on the system)
('vinyl','A Love Supreme','John Coltrane','Played in full. Always.',null,'{"year":1965,"label":"Impulse!","mood":"Devotional","spotify":"7Eoz7hJvaX1eFkbpQxC5PA"}',1),
('vinyl','Sunday at the Village Vanguard','Bill Evans Trio','For rainy Sunday openings.',null,'{"year":1961,"label":"Riverside","mood":"Intimate","spotify":"68e5Cxo3UmbgYbE2tWm8Ov"}',2),
('vinyl','Journey in Satchidananda','Alice Coltrane','Harp, drone, incense hour.',null,'{"year":1971,"label":"Impulse!","mood":"Transcendent","spotify":"6zV55F6W8kh1qe8LHhqRbz"}',3),
('vinyl','The Black Saint and the Sinner Lady','Charles Mingus','The room at full attention.',null,'{"year":1963,"label":"Impulse!","mood":"Orchestral","spotify":"6Sts4Yh7KsDFwq2yTWrGGV"}',4),
('vinyl','Googoosh (Do Panjereh)','Googoosh','Tehran, before. The heart of the shelf.',null,'{"year":1974,"label":"Ahang-e Rooz","mood":"Golden era","spotify":"1q6AOEbGwp5Do8BbJyOEN8"}',5),
('vinyl','Scenery','Ryo Fukui','The kissa canon, note for note.',null,'{"year":1976,"label":"Trio","mood":"Kissa classic","spotify":"5Uny0mkKiVGDat7H6SNDyS"}',6),
('vinyl','In a Silent Way','Miles Davis','Dusk. Lights to half.',null,'{"year":1969,"label":"Columbia","mood":"Electric dusk","spotify":"0Hs3BomCdwIWRhgT57x22T"}',7),
('vinyl','The Epic','Kamasi Washington','The new congregation.',null,'{"year":2015,"label":"Brainfeeder","mood":"Modern spiritual","spotify":"2j2q2ySuVk43eHB8wI5XQj"}',8),
-- magazine issues
('issues','The Door','Autumn 2026','Entry as ritual. The carved door, the maison, and why a café should carry itself like an editorial.',18,'{"no":"No. 1"}',1),
('issues','Full Sides','Winter 2027','The kissa issue — rooms built for listening, from Tokyo to Saint-Jacques.',18,'{"no":"No. 2"}',2),
-- prints
('prints','The Carved Door','Edition of 50',null,120,'{"no":"I","palette":["#2A1B4A","#C9A24B","#7A5C3E"]}',1),
('prints','Faded Grandeur','Edition of 50',null,120,'{"no":"II","palette":["#34245C","#9385AC","#EDE4D3"]}',2),
('prints','Tarnished Gold','Edition of 35',null,160,'{"no":"III","palette":["#C9A24B","#8C6E2E","#1E1238"]}',3),
('prints','Persian Rugs on Stone','Edition of 50',null,120,'{"no":"IV","palette":["#7A2E3E","#C9A24B","#2A1B4A"]}',4),
('prints','The Chahār-Bāgh','Edition of 35',null,160,'{"no":"V","palette":["#2E5C4A","#C8BAD6","#C9A24B"]}',5),
('prints','The Editorial Portrait','Edition of 25',null,220,'{"no":"VI","palette":["#1E1238","#E2C982","#EDE4D3"]}',6),
-- shop vinyl (for sale in The Library)
('shop_vinyl','Scenery','Ryo Fukui','Heard on the system · reissue',48,'{}',1),
('shop_vinyl','Journey in Satchidananda','Alice Coltrane','Heard on the system',42,'{}',2),
('shop_vinyl','Do Panjereh','Googoosh','Original pressing · graded VG+',65,'{}',3),
('shop_vinyl','Sunday at the Village Vanguard','Bill Evans Trio','Heard on the system',38,'{}',4),
-- flowers
('flowers','The Bāgh Bouquet',null,'Rose, tulip, and cypress sprig — the garden, quartered.',55,'{"hue":"#B85C6E"}',1),
('flowers','Cypress & Rose',null,'Stillness and softness, wrapped in bone paper.',42,'{"hue":"#A8434F"}',2),
('flowers','Saffron Crocus',null,'A small burning gold — the kitchen''s favourite.',38,'{"hue":"#C9A24B"}',3),
('flowers','The Single Stem',null,'One perfect flower, for the table or the dedication.',12,'{"hue":"#C8BAD6"}',4),
-- membership tiers
('tiers','The Listener','$45 / month',null,45,'{"cap":"Open cohort","perks":["Member pricing on the bar","Priority seating, day and night","The Broadcast — our printed programme, mailed"]}',1),
('tiers','The Regular','$95 / month',null,95,'{"cap":"Capped at 120","perks":["Everything in The Listener","Reserved listening sessions","Member-only nights & late hours","First access to limited coffee, pastry, releases"]}',2),
('tiers','The Patron','$225 / month',null,225,'{"cap":"Founding table · 40 only","perks":["Everything in The Regular","Your name written in the Member''s Book","A standing reservation","First press of everything the house makes"]}',3);
