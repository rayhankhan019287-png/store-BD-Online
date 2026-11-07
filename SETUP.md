# Store BD Online

A polished English-language storefront built with Next.js 14, React, and Supabase.

## 1. Install

```bash
npm install
npm run dev
`

Open http://localhost:3000.

## 2. Configure Supabase authentication and database

1. Create a project at https://supabase.com.
2. In Project Settings → API, copy the Project URL and anon/public key.
3. Copy `.env.example` to `.env.local` and fill in those values.
4. Open Supabase → SQL Editor and run all contents of `supabase/schema.sql`.
5. Restart the dev server.
6. Use **Create account** on the storefront to register the administrator email first. Confirm the email if email confirmation is enabled.
7. Sign in once with that account. In Supabase SQL Editor, promote the account using:

```sql
update public.profiles set role = 'admin' where email = 'YOUR_ADMIN_EMAIL';
```

8. Sign out and sign back in. Open http://localhost:3000/admin.

## 3. Admin features

The admin dashboard shows registered accounts, login event history, login counts, products and orders. It supports adding and deleting products. Customer signup creates a profile automatically. Login counts are recorded after successful password sign-in.

## 4. Security

- Never commit `.env.local`, service-role keys, or passwords.
- Use a unique strong administrator password and enable email confirmation.
- Promote the admin account only through the Supabase SQL editor.
- Row Level Security policies restrict customer data and admin actions.

## 5. Notes

The homepage includes sample products until your Supabase products table has records. Product checkout/order placement and payment gateway integration are not included yet. The contact/support link opens the Telegram contact provided by the store owner.
