#!/bin/bash

# Quick Vercel Deployment - Troubleshooting Script
# Run this if you're getting "Secret does not exist" errors

echo "========================================"
echo "Vercel Deployment Troubleshooter"
echo "========================================"
echo ""

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI is not installed"
    echo ""
    echo "Install it with:"
    echo "  npm i -g vercel"
    echo ""
    exit 1
else
    echo "✅ Vercel CLI is installed"
fi

# Check if logged in (try to get user info)
if ! vercel whoami &> /dev/null; then
    echo "❌ Not logged in to Vercel"
    echo ""
    echo "Login with:"
    echo "  vercel login"
    echo ""
    exit 1
else
    echo "✅ Logged in to Vercel as: $(vercel whoami)"
fi

# Check if project is linked
if [ ! -d ".vercel" ]; then
    echo "❌ Project is not linked to Vercel"
    echo ""
    echo "Link your project with:"
    echo "  vercel link"
    echo ""
    exit 1
else
    echo "✅ Project is linked to Vercel"
fi

echo ""
echo "========================================"
echo "Checking Secrets"
echo "========================================"
echo ""

# Required secrets
REQUIRED_SECRETS=(
    "database_url"
    "nextauth_url"
    "s3_upload_key"
    "s3_upload_secret"
    "s3_upload_bucket"
    "s3_upload_region"
    "replicate_api_token"
    "replicate_username"
    "next_public_replicate_instance_token"
    "secret"
)

# Get list of secrets
SECRETS_LIST=$(vercel secrets ls 2>/dev/null | tail -n +2 | awk '{print $1}')

MISSING_SECRETS=()

for secret_name in "${REQUIRED_SECRETS[@]}"; do
    if echo "$SECRETS_LIST" | grep -q "^$secret_name$"; then
        echo "✅ $secret_name exists"
    else
        echo "❌ $secret_name is MISSING"
        MISSING_SECRETS+=("$secret_name")
    fi
done

echo ""

if [ ${#MISSING_SECRETS[@]} -eq 0 ]; then
    echo "========================================"
    echo "✅ All Required Secrets Found!"
    echo "========================================"
    echo ""
    echo "You can now deploy with:"
    echo "  vercel --prod"
    echo ""
else
    echo "========================================"
    echo "❌ Missing ${#MISSING_SECRETS[@]} Secret(s)"
    echo "========================================"
    echo ""
    echo "Missing secrets:"
    for secret in "${MISSING_SECRETS[@]}"; do
        echo "  - $secret"
    done
    echo ""
    echo "To fix this, run:"
    echo "  ./scripts/setup-vercel-secrets.sh"
    echo ""
    echo "Or add them manually:"
    for secret in "${MISSING_SECRETS[@]}"; do
        echo "  vercel secrets add $secret"
    done
    echo ""
    echo "For detailed help, see:"
    echo "  - VERCEL_SETUP.md"
    echo "  - vercel.json.md"
    echo ""
fi
