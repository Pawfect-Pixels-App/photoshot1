#!/bin/bash

# Vercel Secrets Setup Script
# This script helps you set up all required secrets for Vercel deployment

set -e

echo "========================================"
echo "Vercel Secrets Setup for Photoshot"
echo "========================================"
echo ""
echo "This script will help you create all the required secrets in Vercel."
echo "You'll need to provide values for each secret when prompted."
echo ""
echo "Prerequisites:"
echo "  - Vercel CLI installed (npm i -g vercel)"
echo "  - Logged in to Vercel (vercel login)"
echo "  - Linked to your Vercel project (vercel link)"
echo ""

read -p "Have you completed the prerequisites above? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please complete the prerequisites first, then run this script again."
    exit 1
fi

echo ""
echo "========================================"
echo "Creating Vercel Secrets"
echo "========================================"
echo ""

# Function to add a secret
add_secret() {
    local secret_name=$1
    local description=$2
    local example=$3
    
    echo ""
    echo "---"
    echo "Secret: $secret_name"
    echo "Description: $description"
    if [ ! -z "$example" ]; then
        echo "Example: $example"
    fi
    echo ""
    
    read -p "Do you want to add this secret now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Running: vercel secrets add $secret_name"
        vercel secrets add "$secret_name" || echo "Warning: Failed to add secret $secret_name (it might already exist)"
    else
        echo "Skipped $secret_name"
    fi
}

# Required Secrets
echo "REQUIRED SECRETS"
echo "================"

add_secret "database_url" \
    "PostgreSQL connection string" \
    "postgresql://user:pass@host:5432/dbname"

add_secret "nextauth_url" \
    "Your application URL (will be your Vercel URL)" \
    "https://your-app.vercel.app"

add_secret "s3_upload_key" \
    "AWS S3 access key ID" \
    "AKIAIOSFODNN7EXAMPLE"

add_secret "s3_upload_secret" \
    "AWS S3 secret access key" \
    "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

add_secret "s3_upload_bucket" \
    "AWS S3 bucket name" \
    "my-photoshot-bucket"

add_secret "s3_upload_region" \
    "AWS S3 region" \
    "us-east-1"

add_secret "replicate_api_token" \
    "Replicate API token from https://replicate.com/account" \
    "r8_***"

add_secret "replicate_username" \
    "Your Replicate username" \
    "your-username"

add_secret "next_public_replicate_instance_token" \
    "Training instance token (3 unique characters)" \
    "abc"

add_secret "secret" \
    "Random string for NextAuth.js (generate with: openssl rand -base64 32)" \
    "your-random-secret-string"

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Verify all secrets were created: vercel secrets ls"
echo "  2. Deploy your application: vercel --prod"
echo ""
echo "Optional: You can also add these secrets via Vercel Dashboard:"
echo "  Project Settings → Environment Variables"
echo ""
echo "Note: If you need to update a secret, remove it first:"
echo "  vercel secrets rm secret_name"
echo "  vercel secrets add secret_name"
echo ""
