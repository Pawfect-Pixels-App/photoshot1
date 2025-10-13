# Copilot Instructions for AI Coding Agents

## Project Overview
This is an open-source AI avatar generator web app built with Next.js, Chakra UI, Prisma, and integrates with Replicate (ML models), Stripe (payments), and AWS S3 (image storage). The app enables users to generate avatars using text-to-image models and manage their projects via a dashboard.

## Architecture & Key Components
- **Frontend:** Located in `src/app/` and `src/components/`. Uses Next.js routing and Chakra UI for styling. Pages and layouts are organized by feature (e.g., dashboard, prompts, gallery).
- **Backend/API:** API routes are in `src/app/api/`. Handles authentication, checkout, and project management. Uses Prisma for database access (`src/core/db.ts`).
- **Database:** Prisma schema in `prisma/schema.prisma`. Migrations in `prisma/migrations/`.
- **Email:** Email templates in `src/components/emails/`. Mailer logic in `src/core/mailer.ts`.
- **Payments:** Stripe integration in `src/lib/stripe.ts`.
- **Sessions/Auth:** NextAuth.js setup in `src/lib/sessions.ts` and type definitions in `src/types/next-auth.d.ts`.
- **Image Storage:** AWS S3 integration via environment variables. Images stored in S3, referenced in the database.

## Developer Workflows
- **Install dependencies:** `yarn install`
- **Start local services:** `docker-compose up -d` (Postgres, Maildev)
- **Environment setup:** Copy `.env.example` to `.env.local` and update values as needed
- **Run migrations:** `yarn prisma:migrate:dev`
- **Start dev server:** `npm run dev` or `yarn dev`
- **Build/Deploy:** Use provided Maven tasks for Java components if present, otherwise standard Next.js build (`npm run build`)
- **Testing:** No explicit test runner found; add tests in `src/` and use standard Next.js/React testing tools

## Patterns & Conventions
- **Routing:** Next.js app router (`src/app/`) with nested folders for features and public pages
- **Context:** Project context via React Context API (`src/contexts/project-context.tsx`)
- **Component Organization:** Feature-based folders under `src/components/`
- **Database Access:** Use Prisma client from `src/core/db.ts`
- **API Integration:** External services (Replicate, Stripe, AWS S3) configured via environment variables
- **Email:** Use template components for transactional emails
- **Type Safety:** TypeScript throughout, with custom types in `src/types/`

## Integration Points
- **Replicate:** ML model API for avatar generation
- **Stripe:** Payment processing for studio features
- **AWS S3:** Image upload and storage
- **OpenAI:** Used for prompt wizard (see environment variables)

## Examples
- To add a new API route, create a file in `src/app/api/` and use Prisma for DB access
- To add a new page, create a folder in `src/app/(public)/` or `src/app/(auth)/` and add a `page.tsx`
- To add a new email template, add a component in `src/components/emails/`

## References
- See `README.md` for setup and environment details
- See `prisma/schema.prisma` for DB structure
- See `src/core/db.ts` for database access patterns
- See `src/components/` for UI and email templates

---

**If any section is unclear or missing, please provide feedback so instructions can be improved.**
