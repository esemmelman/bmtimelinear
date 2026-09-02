# Mitzvah Status

A public, live progress sheet backed by the `bnaimitzvah` Supabase project. Visitors can view every status; the designated owner can unlock editing with their Supabase account password used as a passcode.

## Run locally

```bash
npm install
npm run dev
```

The checked-in defaults point to the `bnaimitzvah` project using its safe, public publishable key. Set `VITE_EDITOR_EMAIL` when deploying if the editor account changes. Never place a service-role key in a `VITE_` variable.

## Editing

Select **Editor access**, enter the password for the configured editor account, choose red/yellow/green (or clear), then select cells. Row-level security prevents all other accounts from writing even if they inspect the browser requests.
