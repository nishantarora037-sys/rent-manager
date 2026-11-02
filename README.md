# Rent Manager

Property rent and collection manager. Single-file web app (`index.html`) with a Supabase database and login.

## Files
- `index.html` – the app. Paste your Supabase URL and anon key at the top of the script.
- `schema.sql` – run once in the Supabase SQL Editor. Edit the owner email on the last lines first.

## Setup
1. Create a free project at supabase.com.
2. SQL Editor: paste `schema.sql` (with your email), then Run.
3. Project Settings > API: copy the Project URL and the **anon public** key (never the service_role key).
4. Put them in `SB_URL` and `SB_KEY` in `index.html`, commit.
5. Host: GitHub Pages (Settings > Pages > Deploy from branch > main / root), Cloudflare Pages or Netlify.
6. In Supabase, Authentication > URL Configuration, set Site URL to your hosted address.
7. Open the site, create an account with the owner email, sign in.
8. Add family: they create an account, then run in the SQL Editor:
   `insert into members(email,role) values ('name@example.com','editor');` (roles: owner, editor, viewer)

## Notes
- Data lives in Supabase, protected by row-level security. The anon key is safe in the page; the service_role key must never be.
- Back up regularly: Settings > Backup JSON.
- Reminders are in-app plus a copyable WhatsApp message. No automatic sending.
