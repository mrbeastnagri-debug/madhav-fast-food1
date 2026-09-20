# Madhav Fast Food — final setup

## 1. GitHub
Upload `index.html` and `supabase.sql` to the repository root.

## 2. Supabase
Open your Supabase project → SQL Editor → paste `supabase.sql` → Run.

## 3. Connect the website
Open `index.html` and find:
- `SUPABASE_URL = ""`
- `SUPABASE_ANON_KEY = ""`

Put your Supabase Project URL and the **anon/public key** there.
Do NOT put a `service_role` key in the website.

## 4. Deploy
Commit the updated `index.html` to GitHub. If Vercel is connected, it will redeploy automatically.

## 5. Owner login
Click Owner on the website.
Password: `Madhav@6268`

## Important
Without the Supabase URL + anon key, the website falls back to browser-local storage. That means changes are NOT shared between different customer phones.

With Supabase configured:
- Menu changes are shared with all customers.
- Uploaded food images are stored in Supabase Storage.
- Orders are stored centrally.
- Owner can add/edit/hide/delete dishes and change shop settings.

For a real production deployment, replace the simple client-side owner password with Supabase Auth before taking sensitive payments.
