# Paluwagan Tracker — Cloud Setup

## 1. Create a Supabase project
1. Go to supabase.com → New project.
2. Once it's ready, open **SQL Editor** → paste the contents of `supabase_schema.sql` → Run.
3. Still in SQL Editor, paste the contents of `supabase_schema_v2_migration.sql` → Run. (This adds member login accounts and per-payment amounts. Skip this step only if you're starting completely fresh and already merged it into `supabase_schema.sql` yourself.)
4. Go to **Project Settings → API** and copy:
   - Project URL
   - `anon` `public` key

## 2. Configure the two HTML files
Open both `admin.html` and `member.html` and replace near the top of the `<script>` block:
```js
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
```
with the values from step 1.

## 3. Set your admin password
The default admin password is `change_me`. Either:
- Update it directly in Supabase: Table Editor → `paluwagan_settings` → edit the `admin_password` cell, **or**
- Log into `admin.html` with `change_me`, then use the "Change password" field in the header.

## 4. Deploy
Push this folder (`admin.html`, `member.html`, `style.css`) to a GitHub repo and deploy on Vercel — same flow as your other tools:
```
vercel --prod
```
No build step needed; it's static files, so the default "Other" framework preset on Vercel works fine.

## 5. Using it
- **You (admin):** go to `https://yourapp.vercel.app/admin.html`, enter the admin password. Add members (a username/password is generated automatically), set the contribution amount and start month, mark payouts, and reorder members.
- **Members:** open the **Member Accounts** tab in admin — it lists each person's username and password (editable, with a "Reset password" shortcut). Share those with them along with `https://yourapp.vercel.app/member.html`.
  - On login, they see a personalized greeting ("Good Morning, Rae! This month is your payout month 🎉" or their upcoming payout month) plus two buttons — **15th Cutoff** and **30th Cutoff** — to self-report their own payments.
  - Tapping a button opens a small popup asking how much they paid. If it's less than the expected ₱1,000, a warning shows before they confirm. Once recorded, that button locks (✓ Paid ₱X) — only you can undo it.
  - Everyone sees the shared Payment Tracker and Calendar update live, with their own row/card highlighted in gold.
- **Removing a mistaken entry:** in admin's Payment Tracker tab, click a green (paid) cutoff cell — it'll ask you to confirm before clearing it. Clicking an unpaid cell lets you manually record a payment on someone's behalf (it'll prompt for the amount too, and warn if it's under ₱1,000).
- **Collected-so-far card:** the summary row now shows actual pesos collected for the 15th, the 30th, and a combined "Collected This Cycle" total against the ₱2,000/member target — not just headcounts.

## Notes on security
This uses the same lightweight model as your other internal tools: the Supabase `anon` key is public in the page source, and row-level security is set to allow read/write to anyone holding that key. Protection comes from the admin password gate, member passwords, and the fact that they're not exposed anywhere public — not from database-level access control. Member passwords are stored in plain text in the `paluwagan_members` table (same convention as your admin password), so treat the Supabase dashboard itself as sensitive, and don't reuse `SUPABASE_ANON_KEY` from a project that holds more sensitive data.

## If you'd rather skip Supabase setup yourself
Send me your Supabase project URL + anon key once created, or ask me to walk you through creating the project, and I can double-check the config before you deploy.
