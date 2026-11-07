# Store BD Online

Modern English-language e-commerce storefront for Bangladesh.

## Quick start
```bash
npm install
npm run dev
```
Open http://localhost:3000.

## Backend setup
See [SETUP.md](./SETUP.md) for Supabase authentication, database schema, admin promotion, and security setup. Copy `.env.example` to `.env.local` and configure your Supabase project. Run `supabase/schema.sql` in the Supabase SQL Editor.

## Included
- Responsive storefront with search and category filters
- Product cards, favourites, local cart, sign-up and sign-in UI
- Supabase profile and login-event tracking
- Admin dashboard for registered accounts, recent sign-ins, product creation/deletion, and order overview
- Store BD Online vector logo and red/black/gold visual identity

## Not included yet
Payment gateway integration and complete order placement/checkout workflow. Demo products appear until you add products in Supabase.
