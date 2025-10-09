# Vercel Deployment Setup Guide

This guide will help you deploy Photoshot to Vercel and resolve the "Environment Variable references Secret which does not exist" error.

## The Problem

When deploying to Vercel, you may encounter this error:

```
Error: Environment Variable "DATABASE_URL" references Secret "database_url", which does not exist.
```

This happens because the `vercel.json` file references Vercel secrets (using `@secret_name` syntax) that haven't been created yet in your Vercel project.

## Solution Overview

You have two options to fix this:

**Option 1 (Recommended):** Create Vercel secrets for all environment variables
**Option 2:** Remove secret references and use plain environment variables

## Option 1: Create Vercel Secrets (Recommended)

Secrets in Vercel are secure, encrypted values that can be reused across multiple projects and environments.

### Prerequisites

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Link your project to Vercel:
   ```bash
   vercel link
   ```
   When prompted:
   - Choose your team/account
   - Select or create a project name
   - Link to the current directory

### Method A: Automated Setup Script

We've provided a script to guide you through creating all required secrets:

```bash
./scripts/setup-vercel-secrets.sh
```

The script will prompt you for each secret value and create them in Vercel.

### Method B: Manual Setup

Create each secret individually using the Vercel CLI:

```bash
# Required secrets
vercel secrets add database_url
# When prompted, enter your PostgreSQL connection string
# Example: postgresql://user:password@host:5432/database

vercel secrets add nextauth_url
# Enter your Vercel deployment URL
# Example: https://your-app.vercel.app

vercel secrets add s3_upload_key
# Enter your AWS S3 access key

vercel secrets add s3_upload_secret
# Enter your AWS S3 secret key

vercel secrets add s3_upload_bucket
# Enter your S3 bucket name

vercel secrets add s3_upload_region
# Enter your S3 region (e.g., us-east-1)

vercel secrets add replicate_api_token
# Enter your Replicate API token from https://replicate.com/account

vercel secrets add replicate_username
# Enter your Replicate username

vercel secrets add next_public_replicate_instance_token
# Enter a 3-character training token (e.g., "abc")

vercel secrets add secret
# Enter a random string (generate with: openssl rand -base64 32)
```

### Method C: Vercel Dashboard

You can also create secrets via the Vercel Dashboard:

1. Go to your Vercel project
2. Navigate to **Settings** → **Environment Variables**
3. For each environment variable in `vercel.json`:
   - Click "Add New"
   - Enter the variable name (e.g., `DATABASE_URL`)
   - Select "Secret" as the type
   - Create or select the corresponding secret (e.g., `database_url`)
   - Choose environments (Production, Preview, Development)
   - Save

### Verify Secrets

List all secrets to verify they were created:

```bash
vercel secrets ls
```

## Option 2: Use Plain Environment Variables

If you prefer not to use secrets, you can modify `vercel.json` to remove secret references:

### Step 1: Update vercel.json

Change the `env` section from:

```json
"env": {
  "DATABASE_URL": "@database_url",
  "NEXTAUTH_URL": "@nextauth_url",
  ...
}
```

To:

```json
"env": {}
```

### Step 2: Add Environment Variables

Then add environment variables directly via:

**CLI:**
```bash
vercel env add DATABASE_URL production
# Enter value when prompted

vercel env add NEXTAUTH_URL production
# Continue for all variables...
```

**Dashboard:**
1. Go to Project Settings → Environment Variables
2. Add each variable with its value
3. Select appropriate environments

## Deploying to Vercel

Once secrets or environment variables are configured:

1. **Deploy to production:**
   ```bash
   vercel --prod
   ```

2. **Or deploy for preview:**
   ```bash
   vercel
   ```

## Required Environment Variables

Here's a complete list of required environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://user:pass@host:5432/db` |
| `NEXTAUTH_URL` | Your Vercel deployment URL | `https://your-app.vercel.app` |
| `S3_UPLOAD_KEY` | AWS S3 access key | `AKIAIOSFODNN7EXAMPLE` |
| `S3_UPLOAD_SECRET` | AWS S3 secret key | `wJalrXUtnFEMI/K7MDENG/...` |
| `S3_UPLOAD_BUCKET` | S3 bucket name | `my-photoshot-bucket` |
| `S3_UPLOAD_REGION` | S3 region | `us-east-1` |
| `REPLICATE_API_TOKEN` | Replicate API token | `r8_***` |
| `REPLICATE_USERNAME` | Replicate username | `your-username` |
| `NEXT_PUBLIC_REPLICATE_INSTANCE_TOKEN` | Training token (3 chars) | `abc` |
| `SECRET` | Random auth secret | Generate with `openssl rand -base64 32` |

## Optional Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `STRIPE_SECRET_KEY` | Stripe API key | - |
| `NEXT_PUBLIC_STRIPE_STUDIO_PRICE` | Price in cents | - |
| `NEXT_PUBLIC_STUDIO_SHOT_AMOUNT` | Max shots per studio | - |
| `OPENAI_API_KEY` | OpenAI API key | - |
| `EMAIL_FROM` | Sender email | - |
| `EMAIL_SERVER` | SMTP server URL | - |

## Updating Secrets

If you need to update a secret:

```bash
# Remove the old secret
vercel secrets rm secret_name

# Add the new secret
vercel secrets add secret_name
```

## Common Issues

### "Secret already exists"

If a secret already exists but has the wrong value:
```bash
vercel secrets rm secret_name
vercel secrets add secret_name
```

### "Variable already added to all environments"

If the environment variable exists but references a non-existent secret:
```bash
vercel env rm VARIABLE_NAME
vercel env add VARIABLE_NAME production
```

### Database Connection Issues

Ensure your database:
- Is accessible from Vercel's IP addresses
- Uses SSL/TLS (add `?sslmode=require` to connection string)
- Has proper permissions for the user

### Deployment Still Fails

1. Check deployment logs: `vercel logs`
2. Verify all secrets exist: `vercel secrets ls`
3. Ensure database migrations can run
4. Check S3 bucket permissions

## Getting Database Connection String

### Neon (Serverless PostgreSQL)
1. Go to [neon.tech](https://neon.tech)
2. Create a project
3. Copy the connection string from dashboard
4. Format: `postgresql://user:pass@xxx.neon.tech/db?sslmode=require`

### Supabase
1. Go to [supabase.com](https://supabase.com)
2. Create a project
3. Go to Project Settings → Database
4. Copy "Session pooler" connection string (recommended for Vercel)
5. Format: `postgresql://postgres:pass@xxx.supabase.co:5432/postgres`

### Railway
1. Create PostgreSQL service in Railway
2. Connection string available as `DATABASE_URL` variable
3. Can reference across services

## Getting AWS S3 Credentials

1. Go to AWS IAM Console
2. Create new user for programmatic access
3. Attach policy with these permissions:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:PutObject",
           "s3:GetObject",
           "s3:DeleteObject"
         ],
         "Resource": "arn:aws:s3:::your-bucket-name/*"
       }
     ]
   }
   ```
4. Save access key ID and secret key

## Getting Replicate Credentials

1. Create account at [replicate.com](https://replicate.com)
2. Go to [Account Settings](https://replicate.com/account)
3. Copy your API token
4. Note your username from profile

## Post-Deployment

After successful deployment:

1. **Update NEXTAUTH_URL**: If you got a Vercel URL, update the `nextauth_url` secret:
   ```bash
   vercel secrets rm nextauth_url
   vercel secrets add nextauth_url
   # Enter your actual Vercel URL
   ```

2. **Test the deployment**:
   - Visit your app URL
   - Try logging in
   - Create a test project
   - Verify S3 uploads work

3. **Set up custom domain** (optional):
   - Go to Project Settings → Domains
   - Add your domain
   - Update `nextauth_url` secret with custom domain

## Additional Resources

- [Vercel Environment Variables Documentation](https://vercel.com/docs/concepts/projects/environment-variables)
- [Vercel Secrets Documentation](https://vercel.com/docs/cli/secrets)
- Main deployment guide: [DEPLOYMENT.md](./DEPLOYMENT.md)
- Quick start: [QUICKSTART.md](./QUICKSTART.md)

## Support

If you're still having issues:
1. Check [existing issues](https://github.com/Pawfect-Pixels-App/photoshot1/issues)
2. Review Vercel deployment logs
3. Open a new issue with:
   - Error message
   - Deployment logs (remove sensitive data)
   - Steps you've tried
