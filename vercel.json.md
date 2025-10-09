# Understanding vercel.json

## What are the @ symbols?

In `vercel.json`, the `@` prefix indicates a **Vercel secret** reference.

For example:
```json
"DATABASE_URL": "@database_url"
```

This means the environment variable `DATABASE_URL` will get its value from a Vercel secret named `database_url`.

## Why use secrets?

Vercel secrets are:
- ✅ Encrypted and stored securely
- ✅ Can be reused across multiple projects
- ✅ Not exposed in deployment logs
- ✅ Easier to rotate/update
- ✅ Separated from your codebase

## How to create secrets

Before deploying, you must create these secrets. Choose one method:

### Method 1: Use the setup script
```bash
./scripts/setup-vercel-secrets.sh
```

### Method 2: Manual CLI
```bash
vercel secrets add database_url
vercel secrets add nextauth_url
vercel secrets add s3_upload_key
# ... etc
```

### Method 3: Vercel Dashboard
1. Go to your project settings
2. Navigate to Environment Variables
3. Create each variable and link to secrets

## Alternative: Don't use secrets

If you prefer not to use secrets, you can:

1. **Remove the secret references** from `vercel.json` by changing:
   ```json
   "env": {
     "DATABASE_URL": "@database_url"
   }
   ```
   
   To:
   ```json
   "env": {}
   ```

2. **Add environment variables directly** via:
   - Vercel Dashboard: Settings → Environment Variables
   - Or CLI: `vercel env add VARIABLE_NAME production`

## Complete Setup Guide

For detailed instructions, see: [VERCEL_SETUP.md](./VERCEL_SETUP.md)

## Current Environment Variables

The following secrets are referenced in `vercel.json`:

| Environment Variable | Secret Name | Description |
|---------------------|-------------|-------------|
| `DATABASE_URL` | `database_url` | PostgreSQL connection string |
| `NEXTAUTH_URL` | `nextauth_url` | Your Vercel app URL |
| `S3_UPLOAD_KEY` | `s3_upload_key` | AWS S3 access key |
| `S3_UPLOAD_SECRET` | `s3_upload_secret` | AWS S3 secret key |
| `S3_UPLOAD_BUCKET` | `s3_upload_bucket` | S3 bucket name |
| `S3_UPLOAD_REGION` | `s3_upload_region` | S3 region |
| `REPLICATE_API_TOKEN` | `replicate_api_token` | Replicate API token |
| `REPLICATE_USERNAME` | `replicate_username` | Replicate username |
| `NEXT_PUBLIC_REPLICATE_INSTANCE_TOKEN` | `next_public_replicate_instance_token` | Training token |
| `SECRET` | `secret` | NextAuth secret |

## Quick Commands

```bash
# List all secrets
vercel secrets ls

# Add a secret
vercel secrets add secret_name

# Remove a secret
vercel secrets rm secret_name

# Deploy after setting up secrets
vercel --prod
```
