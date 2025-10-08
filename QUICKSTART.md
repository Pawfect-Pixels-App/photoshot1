# Quick Start Guide

Get Photoshot up and running in minutes!

## 🚀 Fastest Way: Deploy to Vercel

1. Click the button below:

   [![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/Pawfect-Pixels-App/photoshot1)

2. Set environment variables in Vercel dashboard:
   - `DATABASE_URL` - Get from [Neon](https://neon.tech) or [Supabase](https://supabase.com)
   - `NEXTAUTH_URL` - Your Vercel URL (e.g., `https://your-app.vercel.app`)
   - `S3_UPLOAD_KEY`, `S3_UPLOAD_SECRET`, `S3_UPLOAD_BUCKET`, `S3_UPLOAD_REGION` - AWS S3 credentials
   - `REPLICATE_API_TOKEN`, `REPLICATE_USERNAME` - From [Replicate](https://replicate.com)
   - `NEXT_PUBLIC_REPLICATE_INSTANCE_TOKEN` - Any 3-letter identifier (e.g., "abc")
   - `SECRET` - Random string (generate with `openssl rand -base64 32`)

3. Deploy! 🎉

## 💻 Local Development

### Prerequisites

- Node.js 18+
- Docker (optional, for local database)

### Steps

1. **Clone and install**
   ```bash
   git clone https://github.com/Pawfect-Pixels-App/photoshot1.git
   cd photoshot1
   yarn install
   ```

2. **Start database** (using Docker)
   ```bash
   docker-compose up -d
   ```

3. **Set up environment**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your values
   ```

   Minimum required for local dev:
   ```env
   DATABASE_URL=postgresql://photoshot:photoshot@localhost:5432/photoshot
   NEXTAUTH_URL=http://localhost:3000
   S3_UPLOAD_KEY=your-key
   S3_UPLOAD_SECRET=your-secret
   S3_UPLOAD_BUCKET=your-bucket
   S3_UPLOAD_REGION=us-east-1
   REPLICATE_API_TOKEN=your-token
   REPLICATE_USERNAME=your-username
   NEXT_PUBLIC_REPLICATE_INSTANCE_TOKEN=abc
   SECRET=your-random-secret
   EMAIL_SERVER=smtp://localhost:25
   ```

4. **Run migrations**
   ```bash
   yarn prisma:migrate:dev
   ```

5. **Start development server**
   ```bash
   yarn dev
   ```

6. **Open browser**
   Visit [http://localhost:3000](http://localhost:3000)

## 🐳 Docker Deployment

### Quick Deploy with Docker Compose

1. **Clone repository**
   ```bash
   git clone https://github.com/Pawfect-Pixels-App/photoshot1.git
   cd photoshot1
   ```

2. **Create .env.local**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with production values
   ```

3. **Deploy**
   ```bash
   yarn docker:compose:up
   ```

4. **Access application**
   Visit [http://localhost:3000](http://localhost:3000)

### Using Docker Build

```bash
# Build image
yarn docker:build

# Run container
yarn docker:run
```

## 🔑 Getting API Keys

### Required Services

1. **Database (PostgreSQL)**
   - [Neon](https://neon.tech) - Free tier, serverless
   - [Supabase](https://supabase.com) - Free tier, includes auth
   - [Railway](https://railway.app) - Easy setup with free tier

2. **Storage (S3)**
   - [AWS S3](https://aws.amazon.com/s3/) - Create bucket and IAM user
   - Alternative: [Cloudflare R2](https://www.cloudflare.com/products/r2/) (S3-compatible)

3. **AI Model (Replicate)**
   - Sign up at [Replicate](https://replicate.com)
   - Get API token from account settings
   - Note your username

### Optional Services

4. **Payments (Stripe)**
   - [Stripe](https://stripe.com) - Required for monetization
   - Get secret key from dashboard

5. **Email (SMTP)**
   - [SendGrid](https://sendgrid.com) - Free tier
   - [Mailgun](https://mailgun.com) - Free tier
   - Or use local maildev for development

6. **AI Prompts (OpenAI)**
   - [OpenAI](https://platform.openai.com) - For prompt wizard
   - Get API key from account

## 📱 Testing Your Deployment

1. **Health Check**
   ```bash
   curl https://your-app.com/api/health
   ```

2. **Login Test**
   - Visit your app
   - Click "Sign In"
   - Enter email and check inbox

3. **Create Studio**
   - Upload images
   - Verify S3 upload works
   - Check Replicate training starts

## 🐛 Common Issues

### "Database connection failed"
- Check `DATABASE_URL` is correct
- Ensure database is accessible
- For Neon/Supabase, use connection pooler URL for serverless

### "S3 upload failed"
- Verify IAM user has `s3:PutObject` permission
- Check bucket name and region match
- Ensure bucket is not blocked by CORS

### "Replicate error"
- Verify API token is valid
- Check account has credits
- Ensure username is correct

### "Build fails on Vercel"
- Check all required env vars are set
- Look at build logs for specific error
- Verify Prisma migrations are running

## 📖 Next Steps

- Read full [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed options
- Check [README.md](./README.md) for architecture details
- Customize your deployment
- Set up monitoring and backups

## 🆘 Need Help?

- Open an issue on [GitHub](https://github.com/Pawfect-Pixels-App/photoshot1/issues)
- Check existing documentation
- Review troubleshooting section in DEPLOYMENT.md
