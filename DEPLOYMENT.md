# Deployment Guide

This guide covers multiple deployment options for Photoshot.

## Prerequisites

Before deploying, ensure you have:

- PostgreSQL database (can use managed services like Neon, Supabase, or AWS RDS)
- AWS S3 bucket for image storage
- Replicate API account and token
- Stripe account for payments (optional)
- SMTP server for emails (optional, can use services like SendGrid, Mailgun, or AWS SES)
- OpenAI API key (optional, for prompt wizard feature)

## Environment Variables

All required environment variables are listed in `.env.example`. Copy this file and fill in your values:

```bash
cp .env.example .env.local
```

### Required Variables

- `DATABASE_URL` - PostgreSQL connection string
- `NEXTAUTH_URL` - Your application URL
- `S3_UPLOAD_KEY` - AWS S3 access key
- `S3_UPLOAD_SECRET` - AWS S3 secret key
- `S3_UPLOAD_BUCKET` - AWS S3 bucket name
- `S3_UPLOAD_REGION` - AWS S3 region
- `REPLICATE_API_TOKEN` - Replicate API token
- `REPLICATE_USERNAME` - Replicate username
- `NEXT_PUBLIC_REPLICATE_INSTANCE_TOKEN` - Training identifier (e.g., "abc")
- `SECRET` - Random string for NextAuth.js

### Optional Variables

- `STRIPE_SECRET_KEY` - Stripe API key
- `NEXT_PUBLIC_STRIPE_STUDIO_PRICE` - Studio price in cents
- `NEXT_PUBLIC_STUDIO_SHOT_AMOUNT` - Max shots per studio
- `OPENAI_API_KEY` - OpenAI API key
- `EMAIL_FROM` - Email sender address
- `EMAIL_SERVER` - SMTP server URL

## Deployment Options

### Option 1: Vercel (Recommended)

Vercel is the easiest way to deploy Next.js applications.

#### One-Click Deploy

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/Pawfect-Pixels-App/photoshot1)

#### Manual Deploy

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Deploy:
   ```bash
   vercel
   ```

4. Add environment variables in Vercel dashboard or via CLI:
   ```bash
   vercel env add DATABASE_URL
   vercel env add NEXTAUTH_URL
   # ... add all other environment variables
   ```

5. Deploy to production:
   ```bash
   vercel --prod
   ```

#### Important Notes for Vercel

- Database migrations run automatically via `vercel-build` script
- Add all environment variables in the Vercel dashboard under Project Settings → Environment Variables
- Set `NEXTAUTH_URL` to your Vercel deployment URL (e.g., `https://your-app.vercel.app`)

### Option 2: Docker

Deploy using Docker for more control over your infrastructure.

#### Build Docker Image

```bash
docker build -t photoshot .
```

#### Run with Docker Compose

```bash
# Start database and application
docker-compose -f docker-compose.prod.yml up -d
```

#### Run Standalone Container

```bash
docker run -d \
  --name photoshot \
  -p 3000:3000 \
  --env-file .env.local \
  photoshot
```

### Option 3: Railway

[Railway](https://railway.app) provides easy deployment with PostgreSQL included.

1. Click: [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

2. Add environment variables in Railway dashboard

3. Railway will automatically:
   - Provision a PostgreSQL database
   - Set `DATABASE_URL` environment variable
   - Deploy your application

### Option 4: Render

[Render](https://render.com) offers free PostgreSQL and static site hosting.

1. Create a new Web Service on Render

2. Connect your GitHub repository

3. Configure:
   - Build Command: `yarn install && yarn build`
   - Start Command: `yarn start`

4. Add environment variables in Render dashboard

5. Render will automatically deploy on every push to main branch

### Option 5: Self-Hosted (VPS)

Deploy on your own server (AWS EC2, DigitalOcean, etc.).

#### Requirements

- Node.js 18+
- PostgreSQL 14+
- PM2 or similar process manager

#### Setup Steps

1. Clone repository:
   ```bash
   git clone https://github.com/Pawfect-Pixels-App/photoshot1.git
   cd photoshot1
   ```

2. Install dependencies:
   ```bash
   yarn install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your values
   ```

4. Run database migrations:
   ```bash
   yarn prisma:migrate:dev
   ```

5. Build application:
   ```bash
   yarn build
   ```

6. Start application with PM2:
   ```bash
   pm2 start yarn --name photoshot -- start
   pm2 save
   pm2 startup
   ```

7. Set up Nginx as reverse proxy (optional):
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

## Database Setup

### Using Local PostgreSQL

If using the provided `docker-compose.yml`:

```bash
docker-compose up -d postgres
```

Connection string: `postgresql://photoshot:photoshot@localhost:5432/photoshot`

### Using Managed Database Services

#### Neon (Serverless PostgreSQL)

1. Create account at [neon.tech](https://neon.tech)
2. Create new project
3. Copy connection string
4. Set as `DATABASE_URL` environment variable

#### Supabase

1. Create account at [supabase.com](https://supabase.com)
2. Create new project
3. Go to Project Settings → Database
4. Copy connection string (choose "Session pooler" for Vercel)
5. Set as `DATABASE_URL` environment variable

#### Railway PostgreSQL

1. Create PostgreSQL service in Railway
2. Connection string automatically available as `DATABASE_URL`

## Post-Deployment

### Run Database Migrations

Ensure migrations are applied:

```bash
yarn prisma migrate deploy
```

### Verify Deployment

1. Check health endpoint: `GET /api/health`
2. Test authentication: Visit `/login`
3. Verify S3 upload: Try creating a project
4. Check Replicate integration: Start a training job

### Monitoring

Consider adding:

- [Sentry](https://sentry.io) for error tracking
- [LogRocket](https://logrocket.com) for session replay
- Uptime monitoring (UptimeRobot, Better Uptime)

## Troubleshooting

### Build Failures

**Error: Prisma Client not generated**
```bash
yarn prisma generate
```

**Error: Database connection failed**
- Check `DATABASE_URL` format
- Ensure database is accessible from deployment environment
- Verify database user has necessary permissions

### Runtime Issues

**Error: S3 upload failed**
- Verify S3 credentials and bucket name
- Check bucket permissions (should allow PutObject)
- Ensure bucket region matches `S3_UPLOAD_REGION`

**Error: Replicate training failed**
- Verify Replicate API token
- Check Replicate account has sufficient credits
- Ensure `REPLICATE_USERNAME` is correct

## Scaling Considerations

- Enable Next.js Image Optimization with CDN
- Use database connection pooling (PgBouncer)
- Consider Redis for session storage
- Set up horizontal scaling with load balancer
- Monitor and optimize Replicate costs

## Security Checklist

- [ ] All environment variables set securely
- [ ] `SECRET` is a strong random string
- [ ] Database has restricted access (not public)
- [ ] S3 bucket has appropriate permissions
- [ ] HTTPS enabled (automatic on Vercel)
- [ ] Regular dependency updates
- [ ] Monitor for security vulnerabilities

## Support

For issues or questions:
- Open an issue on [GitHub](https://github.com/Pawfect-Pixels-App/photoshot1/issues)
- Check existing documentation in README.md
