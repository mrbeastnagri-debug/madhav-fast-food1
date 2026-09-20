# Madhav Fast Food — shared online ordering version

This version keeps the original customer/admin flow but moves menu, images, orders and settings to Supabase so they can be shared across phones.

## 1. Create Supabase project
Create a project at Supabase.

## 2. Run SQL
Open SQL Editor and run `supabase.sql` completely.

## 3. Create owner login
In Supabase Dashboard → Authentication → Users, create an owner user.
Use any email you control and set the password to:

`Madhav@6268`

The password is NOT hard-coded into the public website.

## 4. Add Supabase keys
Open `index.html` and replace:

`PASTE_YOUR_SUPABASE_PROJECT_URL`

and

`PASTE_YOUR_SUPABASE_ANON_KEY`

Get them from Supabase → Project Settings → API.

Only the Project URL and anon/public key belong in this file. Never use the service_role/secret key.

## 5. Test
Open the site:
- Customer: menu loads from database.
- Owner → login → add/edit/delete dish.
- Upload a dish image and save.
- Open the public site on another phone: the same image/menu appears.
- Place an order from customer phone.
- Owner dashboard receives the order.
- Change status.
- Customer can track with Order ID + mobile number.

## 6. Deploy
Upload the folder to GitHub and connect the repository to Vercel. Framework preset can be `Other`; no build command is required.

### Important
The frontend is intentionally not given the service_role key. Supabase RLS controls the database. For a production business, the public order tracking policy should be tightened further if you want stronger privacy.
